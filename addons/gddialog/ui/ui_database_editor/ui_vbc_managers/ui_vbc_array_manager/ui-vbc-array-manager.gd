@tool
extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditArrayName: LineEdit = get_node(
		"HBCArrayOptions/LineEditArrayName" )
@onready var nItemListArrays: ItemList = get_node( "ItemListArrays" )


func add_array_to_arrays_list(
		new_array: String,
		load: bool = false
) -> void:
	if( load == false ):
		if( new_array.length() == 0
			or owner.nDatabase.string_arrays_list.has( new_array )
		):
			print( "Array %s already exists" % new_array )
			return
		#	End defensive return.
		owner.nDatabase.add_array_to_arrays_list( new_array )
	nItemListArrays.add_item( new_array )
	nItemListArrays.sort_items_by_text()
	#	Clearing the lineedit for ease of use.
	nLineEditArrayName.clear()
	owner.set_filename_label_modified( true )


func remove_selected_arrays_from_arrays_list() -> void:
	if( nItemListArrays.is_anything_selected() == false ):
		return
	#	End defensive return.
	var selected_array_ids: Array = nItemListArrays.get_selected_items()
	for i in range( selected_array_ids.size() ):
		var array_id = selected_array_ids[ selected_array_ids.size() - 1 - i ]
		var array_name: String = nItemListArrays.get_item_text( array_id )
		nItemListArrays.remove_item( array_id )
		owner.nDatabase.remove_array_from_arrays_list( array_name )


func populate_arrays_in_item_list() -> void:
	nItemListArrays.clear()
	for array in owner.nDatabase.string_arrays_list:
		nItemListArrays.add_item( array )
	nItemListArrays.sort_items_by_text()
