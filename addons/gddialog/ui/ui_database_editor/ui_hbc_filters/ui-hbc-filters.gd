@tool
extends HBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditSearch: LineEdit = get_node( "LineEditSearch" )
@onready var nOptionButtonSearchBy: OptionButton = get_node( 
		"OptionButtonSearchBy" )
@onready var nCheckBoxTagFilter: CheckBox = get_node( "CheckBoxTagFilter" )
@onready var nMenuButtonFilterTags: MenuButton = get_node( 
		"MenuButtonFilterTags" )


""" Search Features """


func set_all_records_visible( value: bool ) -> void:
	var records = owner.nVBCDialogRecords.get_children()
	for record in records:
		record.visible = value


func update_filter() -> void:
	var filter_text: String = nLineEditSearch.text
	set_all_records_visible( true )
	var selected_tags: Array
	var nFilterMenu: PopupMenu = nMenuButtonFilterTags.get_popup()
	for tag in range( nFilterMenu.get_item_count() ):
		if( nFilterMenu.is_item_checked( tag ) ):
			var tag_name: String = nFilterMenu.get_item_text( tag )
			selected_tags.push_back( tag_name )
	var records: Array = owner.nVBCDialogRecords.get_children()
	var filter_option: int = nOptionButtonSearchBy.selected
	for record in records:
		var id: int = record.get_record_id()
		var matched: bool = true
		if( filter_text.length() != 0 ):
			matched = false
			match filter_option:
				0:
					if( owner.nDatabase.database[ id ].has( "name" ) ):
						var record_name = (
								owner.nDatabase.database[ id ][ "name" ] )
						if( record_name.find( filter_text ) > -1 ):
							matched = true
				1:
					var record_desc = (
							owner.nDatabase.database[ id ][ "description" ] )
					if( record_desc.find( filter_text ) > -1 ):
							matched = true
				2:
					if( str( id ) == filter_text ):
						matched = true
		#	Filtering out records that don't fit the selected tags.
		if( matched == true
			and nCheckBoxTagFilter.button_pressed == true
			and nFilterMenu.get_item_count() > 1
		):
			matched = false
			var record_tags: Array = owner.nDatabase.get_record_tags( id )
			if( record_tags.size() == 0
				and selected_tags.has( "Include Untagged" )
			):
				matched = true
			else:
				#	Next we go through the record tags for any matches.
				for tag_name in record_tags:
					if( selected_tags.has( tag_name ) ):
						matched = true
		record.visible = matched


func toggle_filter_tag( tag: int ) -> void:
	var nFilterMenu: PopupMenu = nMenuButtonFilterTags.get_popup()
	var checked: bool = nFilterMenu.is_item_checked( tag )
	nFilterMenu.set_item_checked( tag, not checked )
	if( nCheckBoxTagFilter.button_pressed == true ):
		update_filter()


func populate_filter_menu() -> void:
	var nFilterMenu: PopupMenu = nMenuButtonFilterTags.get_popup()
	nFilterMenu.clear()
	nFilterMenu.add_check_item( "Include Untagged" )
	for tag_name in owner.nDatabase.tags_list:
		nFilterMenu.add_check_item( tag_name )
	for tag in range( nFilterMenu.get_item_count() ):
		nFilterMenu.set_item_checked( tag, true )


func _ready() -> void:
	nMenuButtonFilterTags.get_popup().hide_on_checkable_item_selection = false
	nSignals.connect_setup_signals()


func destroy() -> void:
	nSignals.disconnect_setup_signals()
