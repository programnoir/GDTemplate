@tool
extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditNewTag: LineEdit = get_node(
		"HBCTagOptions/LineEditNewTag" )
@onready var nItemListTags: ItemList = get_node( "ItemListTags" )


func add_tag_to_tags_list( new_tag: String, load: bool = false ) -> void:
	if( load == false ):
		if( new_tag.length() == 0
			or owner.nDatabase.tags_list.has( new_tag )
		):
			print( "Tag %s already exists" % new_tag )
			return
		#	End defensive return.
		owner.nDatabase.add_tag_to_tags_list( new_tag )
	nItemListTags.add_item( new_tag )
	#	Sorting alphabetically because we sorted the internal tag list.
	nItemListTags.sort_items_by_text()
	nLineEditNewTag.clear()
	#	Repopulating the search filter tags.
	owner.nHBCFilters.populate_filter_menu()


func manage_tags_on_checked_records(
		assigning: bool,
		deleting: bool = false
) -> void:
	#	This function only returns the indices of the items.
	var selected_tag_ids: Array = nItemListTags.get_selected_items()
	for i in range( selected_tag_ids.size() ):
		var tag_id: int
		if( assigning == true ):
			tag_id = selected_tag_ids[ i ]
		else:
			#	Iterating backwards to avoid out-of-bounds errors.
			tag_id = selected_tag_ids[ selected_tag_ids.size() - 1 - i ]
		var tag_name: String = nItemListTags.get_item_text( tag_id )
		for record in owner.checked_records:
			var record_id = record.get_record_id()
			if( assigning == false ):
				var was_untagged = owner.nDatabase.remove_tag_from_record(
						record_id, tag_name )
				if( was_untagged == true ):
					record.remove_tag_from_tag_list( tag_name )
			else:
				var was_tagged = owner.nDatabase.add_tag_to_record(
						record_id, tag_name )
				if( was_tagged == true ):
					record.add_tag_to_tag_list( tag_name )
		if( deleting == true ):
			owner.nDatabase.remove_tag_from_tags_list( tag_name )
			nItemListTags.remove_item( tag_id )


func populate_tags_in_item_list() -> void:
	for tag in owner.nDatabase.tags_list:
		nItemListTags.add_item( tag )
	owner.nHBCFilters.populate_filter_menu()
