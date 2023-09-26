@tool
extends VBoxContainer

@onready var nLineEditFlagName: LineEdit = get_node(
		"HBCFlagOptions/LineEditFlagName" )
@onready var nItemListFlags: ItemList = get_node( "ItemListFlags" )


func add_flag_to_flags_list( new_flag: String, load: bool = false ) -> void:
	if( load == false ):
		if( new_flag.length() == 0
			or owner.nDatabase.flags_list.has( new_flag )
		):
			print( "Flag %s already exists" % new_flag )
			return
		#	End defensive return.
		owner.nDatabase.add_flag_to_flags_list( new_flag )
	nItemListFlags.add_item( new_flag )
	nItemListFlags.sort_items_by_text()
	nLineEditFlagName.clear()
	owner.set_filename_label_modified( true )


func remove_selected_flags_from_flags_list() -> void:
	if( nItemListFlags.is_anything_selected() == false ):
		return
	#	End defensive return.
	var selected_flag_ids: Array = nItemListFlags.get_selected_items()
	for i in range( selected_flag_ids.size() ):
		var flag_id = selected_flag_ids[ selected_flag_ids.size() - 1 - i ]
		var flag_name: String = nItemListFlags.get_item_text( flag_id )
		nItemListFlags.remove_item( flag_id )
		owner.nDatabase.remove_flag_from_flags_list( flag_name )


func populate_flags_in_item_list() -> void:
	nItemListFlags.clear()
	for flag in owner.nDatabase.flags_list:
		nItemListFlags.add_item( flag )
	nItemListFlags.sort_items_by_text()
