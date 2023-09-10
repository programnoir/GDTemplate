@tool
extends Control

signal switch_control

@onready var nSignals: Node = get_node( "Signals" )
@onready var nFile: Node = get_node( "File" )
@onready var nDatabase: Node = get_node( "Database" )

@onready var nMenuButtonFile: Node = get_node( "VBoxContainer/HBCEditorMenu"\
		+ "/MenuButtonFile" )
@onready var nMenuButtonEdit: Node = get_node( "VBoxContainer/HBCEditorMenu"\
		+ "/MenuButtonEdit" )
@onready var nMenuButtonView: Node = get_node( "VBoxContainer/HBCEditorMenu"\
		+ "/MenuButtonView" )
@onready var nPanelWorkspace: Panel = get_node( "VBoxContainer"\
		+ "/HBCWorkspace/PanelWorkspace" )
@onready var nVBCDialogRecords: VBoxContainer = nPanelWorkspace.get_node( 
			"SCRecords/VBCDialogRecords" )
@onready var nLabelFileName: Label = get_node( "VBoxContainer"\
		+ "/HBCEditorMenu/LabelFileName" )
#	Managers
@onready var nVBCManagers: VBoxContainer = get_node( "VBoxContainer"\
		+ "/HBCWorkspace/VBCManagers" )
@onready var nLabelManagerTitle: Label = get_node( "VBoxContainer"\
		+ "/HBCWorkspace/VBCManagers/HBCManagerTitle/LabelManagerTitle" )
@onready var nVBCFlagManager: VBoxContainer = nVBCManagers.get_node(
		"VBCFlagManager" )
@onready var nLineEditFlagName: LineEdit = nVBCFlagManager.get_node(
		"HBCFlagOptions/LineEditFlagName" )
@onready var nItemListFlags: ItemList = nVBCFlagManager.get_node(
		"ItemListFlags" )
@onready var nVBCStringManager: VBoxContainer = nVBCManagers.get_node(
		"VBCStringManager" )
@onready var nLineEditNewString: LineEdit = nVBCStringManager.get_node(
		"HBCStringOptions/LineEditNewString" )
@onready var nVBCStrings: VBoxContainer = nVBCStringManager.get_node(
		"SCStrings/VBCStrings" )
@onready var nVBCFloatManager: VBoxContainer = nVBCManagers.get_node(
		"VBCFloatManager" )
@onready var nLineEditNewFloat: LineEdit = nVBCFloatManager.get_node(
		"HBCFloatOptions/LineEditNewFloat" )
@onready var nVBCFloats: VBoxContainer = nVBCFloatManager.get_node(
		"SCFloats/VBCFloats" )
@onready var nVBCArrayManager: VBoxContainer = nVBCManagers.get_node(
		"VBCArrayManager" )
@onready var nLineEditArrayName: LineEdit = nVBCArrayManager.get_node(
		"HBCArrayOptions/LineEditArrayName" )
@onready var nItemListArrays: ItemList = nVBCArrayManager.get_node(
		"ItemListArrays" )
@onready var nVBCColorManager: VBoxContainer = nVBCManagers.get_node(
		"VBCColorManager" )
@onready var nLineEditAddColor: LineEdit = nVBCColorManager.get_node(
		"HBCColorOptions/LineEditAddColor" )
@onready var nVBCColors: VBoxContainer = nVBCColorManager.get_node(
		"SCColors/VBCColors" )
@onready var nVBCSpeakerManager: VBoxContainer = nVBCManagers.get_node(
		"VBCSpeakerManager" )
@onready var nLineEditAddSpeaker: LineEdit = nVBCSpeakerManager.get_node(
		"HBCSpeakerOptions/LineEditAddSpeaker" )
@onready var nVBCSpeakers: VBoxContainer = nVBCSpeakerManager.get_node(
		"SCSpeakers/VBCSpeakers" )

@onready var nVBCTagManager: VBoxContainer = nVBCManagers.get_node(
		"VBCTagManager" )
@onready var nLineEditNewTag: LineEdit = nVBCTagManager.get_node(
		"HBCTagOptions/LineEditNewTag" )
@onready var nItemListTags: ItemList = nVBCTagManager.get_node( "ItemListTags" )
#	Search Filter Controls
@onready var nHBCFilters: HBoxContainer = get_node( "VBoxContainer"\
		+ "/HBCFilters" )
@onready var nLineEditSearch: LineEdit = nHBCFilters.get_node(
		"LineEditSearch" )
@onready var nOptionButtonSearchBy: OptionButton = nHBCFilters.get_node( 
		"OptionButtonSearchBy" )
@onready var nCheckBoxTagFilter: CheckBox = nHBCFilters.get_node( 
		"CheckBoxTagFilter" )
@onready var nMenuButtonFilterTags: MenuButton = nHBCFilters.get_node( 
		"MenuButtonFilterTags" )

#	The default name for a record.
const DEFAULT_RECORD_NAME: String = "record-name"
#	The dialog editor.
var dialog_editor: Control
#	A list of currently checked records.
var checked_records: Array = []
#	Whenever we rename a record, we need info about the record currently being
#	 modified in case there are problems with that record.
var current_modified_record: DialogRecordRow = null

#	These are the rows that appear in nVBCDialogRecords.
var p_UIRecordRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_record_row/ui-record-row.tscn")
#	These are rows that appear in the string manager.
var p_UIStringRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_string_row/ui-string-row.tscn" )
var p_UIFloatRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_float_row/ui-float-row.tscn" )
var p_UIColorRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_color_row/ui-color-row.tscn" )
var p_UISpeakerRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_speaker_row/ui-speaker-row.tscn" )


func set_dialog_editor( editor: Control ) -> void:
	dialog_editor = editor
	dialog_editor.set_database( nDatabase )


""" Editor Utilities """


func set_filename_label_modified( modified: bool = true ) -> void:
	var marked_modified: bool = nLabelFileName.text.ends_with( "*" )
	if( ( marked_modified == modified ) ):
		return
	#	End defensive return: No new changes needed.
	var new_color: Color = Color( 1.0, 1.0, 1.0 )
	var modification_marker: String = ""
	if( modified == true ):
		new_color = Color( 1.0, 1.0, 0.0 )
		modification_marker = "*"
	nLabelFileName.set( "custom_colors/font_color",
			new_color )
	nLabelFileName.text = nLabelFileName.text + modification_marker


func toggle_record_checked( record: DialogRecordRow, checked: bool ) -> void:
	if( checked == true and checked_records.has( record ) == false ):
		checked_records.push_front( record )
	elif( checked == false and checked_records.has( record ) == true ):
		checked_records.erase( record )


func set_checked_all_visible_records( ticked: bool ) -> void:
	var records = nVBCDialogRecords.get_children()
	for record in records:
		if( record.visible == true ):
			toggle_record_checked( record, ticked )
			record.set_record_checked( ticked )


""" Database Modifications """


func set_current_modified_record( new_record: DialogRecordRow ) -> void:
	current_modified_record = new_record


func dialog_editor_choose_record( record_id: int ) -> void:
	dialog_editor.set_record_info( record_id )
	dialog_editor.populate_graph()
	dialog_editor.connect_all_node_link_ui()


func delete_dialog_record( record: DialogRecordRow ) -> void:
	nDatabase.delete_dialog_record( record )
	nSignals.disconnect_record_signals( record )
	record.destroy()
	set_filename_label_modified( true )


func delete_checked_visible_dialogs() -> void:
	var array_length = checked_records.size()
	for i in range( array_length ):
		#	Iterating instead of popping because it may be invisible.
		var record = checked_records[ array_length - 1 - i ]
		if( record.visible == true ):
			toggle_record_checked( record, false )
			delete_dialog_record( record )


func create_dialog_record() -> void:
	var new_record_id: int = nDatabase.create_dialog_record()
	var new_record: DialogRecordRow = p_UIRecordRow.instantiate()
	nVBCDialogRecords.add_child( new_record )
	new_record.set_record_id( new_record_id )
	nSignals.connect_record_signals( new_record )
	set_filename_label_modified( true )


""" Managers """


func add_flag_to_flags_list( new_flag: String, load: bool = false ) -> void:
	if( load == false ):
		if( new_flag.length() == 0 or nDatabase.flags_list.has( new_flag ) ):
			print( "Flag %s already exists" % new_flag )
			return
		#	End defensive return.
		nDatabase.add_flag_to_flags_list( new_flag )
	nItemListFlags.add_item( new_flag )
	nItemListFlags.sort_items_by_text()
	#	Clearing the lineedit for ease of use.
	nLineEditFlagName.clear()
	#	Repopulating the search filter tags.
	set_filename_label_modified( true )


func remove_selected_flags_from_flags_list() -> void:
	if( nItemListFlags.is_anything_selected() == false ):
		return
	#	End defensive return.
	var selected_flag_ids: Array = nItemListFlags.get_selected_items()
	for i in range( selected_flag_ids.size() ):
		var flag_id = selected_flag_ids[ selected_flag_ids.size() - 1 - i ]
		var flag_name: String = nItemListFlags.get_item_text( flag_id )
		nItemListFlags.remove_item( flag_id )
		nDatabase.remove_flag_from_flags_list( flag_name )



func add_array_to_arrays_list(
		new_array: String,
		load: bool = false
) -> void:
	if( load == false ):
		if(
			new_array.length() == 0
			or nDatabase.string_arrays_list.has( new_array )
		):
			print( "Array %s already exists" % new_array )
			return
		#	End defensive return.
		nDatabase.add_array_to_arrays_list( new_array )
	nItemListArrays.add_item( new_array )
	nItemListArrays.sort_items_by_text()
	#	Clearing the lineedit for ease of use.
	nLineEditArrayName.clear()
	set_filename_label_modified( true )


func remove_selected_arrays_from_arrays_list() -> void:
	if( nItemListArrays.is_anything_selected() == false ):
		return
	#	End defensive return.
	var selected_array_ids: Array = nItemListArrays.get_selected_items()
	for i in range( selected_array_ids.size() ):
		var array_id = selected_array_ids[ selected_array_ids.size() - 1 - i ]
		var array_name: String = nItemListFlags.get_item_text( array_id )
		nItemListArrays.remove_item( array_id )
		nDatabase.remove_array_from_arrays_list( array_name )


func create_string_variable(
		string_name: String,
		load: bool = false
) -> DialogStringRow:
	if( load == false ):
		if( nDatabase.add_string_variable( string_name ) == false ):
			return
		#	End defensive return: String exists/invalid name
	var new_row: DialogStringRow = p_UIStringRow.instantiate()
	nVBCStrings.add_child( new_row )
	new_row.set_name_ui( string_name )
	nSignals.connect_string_signals( new_row )
	nLineEditNewString.clear()
	set_filename_label_modified( true )
	return new_row


func create_float_variable(
		float_name: String,
		load: bool = false
) -> DialogFloatRow:
	if( load == false ):
		if( nDatabase.add_float_variable( float_name ) == false ):
			return
		#	End defensive return: String exists/invalid
	var new_row: DialogFloatRow = p_UIFloatRow.instantiate()
	nVBCFloats.add_child( new_row )
	new_row.set_name_ui( float_name )
	nSignals.connect_float_signals( new_row )
	nLineEditNewFloat.clear()
	set_filename_label_modified( true )
	return new_row


func create_color_variable(
		color_name: String,
		load: bool = false
) -> DialogColorRow:
	if( load == false ):
		if( nDatabase.add_color_variable( color_name ) == false ):
			return
		#	End defensive return: String exists/invalid
	var new_row: DialogColorRow = p_UIColorRow.instantiate()
	nVBCColors.add_child( new_row )
	new_row.set_name_ui( color_name )
	nSignals.connect_color_signals( new_row )
	nLineEditAddColor.clear()
	set_filename_label_modified( true )
	return new_row


func create_speaker_variable(
		speaker_name: String,
		load: bool = false
) -> DialogSpeakerRow:
	if( load == false ):
		if( nDatabase.add_speaker_variable( speaker_name ) == false ):
			return
		#	End defensive return: String exists/invalid
	var new_row: DialogSpeakerRow = p_UISpeakerRow.instantiate()
	nVBCSpeakers.add_child( new_row )
	new_row.set_name_ui( speaker_name )
	nSignals.connect_speaker_signals( new_row )
	nLineEditAddSpeaker.clear()
	set_filename_label_modified( true )
	return new_row


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
		for record in checked_records:
			var record_id = record.get_record_id()
			if( assigning == false ):
				var was_untagged = nDatabase.remove_tag_from_record(
						record_id, tag_name )
				if( was_untagged == true ):
					record.remove_tag_from_tag_list( tag_name )
			else:
				var was_tagged = nDatabase.add_tag_to_record(
						record_id, tag_name )
				if( was_tagged == true ):
					record.add_tag_to_tag_list( tag_name )
		if( deleting == true ):
			nDatabase.remove_tag_from_tags_list( tag_name )
			nItemListTags.remove_item( tag_id )


""" Deleting Variables """


func delete_string_variable( row: DialogStringRow ) -> void:
	#	Disconnect signals
	nSignals.disconnect_string_signals( row )
	nDatabase.delete_string_variable( row.get_string_name() )
	row.destroy()


func delete_float_variable( row: DialogFloatRow ) -> void:
	#	Disconnect signals
	nSignals.disconnect_float_signals( row )
	nDatabase.delete_float_variable( row.get_float_name() )
	row.destroy()


func delete_speaker_variable( row: DialogSpeakerRow ) -> void:
	#	Disconnect signals
	nSignals.disconnect_speaker_signals( row )
	nDatabase.delete_speaker_variable( row.get_speaker_name() )
	row.destroy()


func delete_color_variable( row: DialogColorRow ) -> void:
	#	Disconnect signals
	nSignals.disconnect_color_signals( row )
	nDatabase.delete_color_variable( row.get_color_name() )
	row.destroy()


""" Search Features """


func set_all_records_visible( value: bool ) -> void:
	var records = nVBCDialogRecords.get_children()
	for record in records:
		record.visible = value


func update_filter() -> void:
	var filter_text: String = nLineEditSearch.text
	set_all_records_visible( true )
	#	Fill an array with the tags we have selected to filter by.
	var selected_tags: Array
	var nFilterMenu: PopupMenu = nMenuButtonFilterTags.get_popup()
	for tag in range( nFilterMenu.get_item_count() ):
		if( nFilterMenu.is_item_checked( tag ) ):
			var tag_name: String = nFilterMenu.get_item_text( tag )
			selected_tags.push_back( tag_name )
	#	Now we gather the records we will be filtering.
	var records: Array = nVBCDialogRecords.get_children()
	#	Are we filtering by Name/Description/ID/etc?
	var filter_option: int = nOptionButtonSearchBy.selected
	#	Now to do the record filtering.
	for record in records:
		var id: int = record.get_record_id()
		var matched: bool = true
		if( filter_text.length() != 0 ):
			matched = false
			match filter_option:
				0: #	Name
					if( nDatabase.database[ id ].has( "name" ) ):
						#	Search the name for the string.
						var record_name = nDatabase.database[ id ][ "name" ]
						if( record_name.find( filter_text ) > -1 ):
							matched = true
				1: #	Description
					var record_desc = nDatabase.database[ id ][ "description" ]
					if( record_desc.find( filter_text ) > -1 ):
							matched = true
				2: #	ID
					if( str( id ) == filter_text ):
						matched = true
		#	Of the ones that match the above result, we want to filter out
		#	 records that don't fit any of the selected tags.
		if( matched == true
			and nCheckBoxTagFilter.button_pressed == true
			and nFilterMenu.get_item_count() > 1
		):
			matched = false
			#	"Include Untagged" means show the ones with no tags at all.
			#	Excludes records that don't have at least one checked tag.
			#	First, let's get all of the tags in a record.
			var record_tags: Array = nDatabase.get_record_tags( id )
			#	The only way untagged records get included.
			if( record_tags.size() == 0
				and selected_tags.has( "Include Untagged" )
			):
				matched = true
			else:
				#	Next we go through the record tags for any matches.
				for tag_name in record_tags:
					if( selected_tags.has( tag_name ) ):
						matched = true
		#	Set the record's visibility to the result.
		record.visible = matched


func populate_filter_menu() -> void:
	var nFilterMenu: PopupMenu = nMenuButtonFilterTags.get_popup()
	nFilterMenu.clear()
	nFilterMenu.add_check_item( "Include Untagged" )
	for tag_name in nDatabase.tags_list:
		nFilterMenu.add_check_item( tag_name )
	for tag in range( nFilterMenu.get_item_count() ):
		nFilterMenu.set_item_checked( tag, true )


func add_tag_to_tags_list( new_tag: String, load: bool = false ) -> void:
	if( load == false ):
		if( new_tag.length() == 0 or nDatabase.tags_list.has( new_tag ) ):
			print( "Tag %s already exists" % new_tag )
			return
		#	End defensive return.
		nDatabase.add_tag_to_tags_list( new_tag )
	nItemListTags.add_item( new_tag )
	#	Sorting alphabetically because we sorted the internal tag list.
	nItemListTags.sort_items_by_text()
	nLineEditNewTag.clear()
	#	Repopulating the search filter tags.
	populate_filter_menu()


""" Loading Variables """


func populate_arrays_in_item_list() -> void:
	nItemListArrays.clear()
	for array in nDatabase.string_arrays_list:
		nItemListArrays.add_item( array )
	nItemListArrays.sort_items_by_text()


#	Currently will fail because of the defensive return
func populate_strings_in_manager() -> void:
	for string_row in nDatabase.strings_list.keys():
		var new_row: DialogStringRow = create_string_variable(
				string_row, true )
		new_row.set_value_ui( nDatabase.strings_list[ string_row ] )


func populate_floats_in_manager() -> void:
	for float_row in nDatabase.floats_list.keys():
		var new_row: DialogFloatRow = create_float_variable(
				float_row, true )
		new_row.set_value_ui( nDatabase.floats_list[ float_row ] )


func populate_colors_in_manager() -> void:
	for color_row in nDatabase.colors_list.keys():
		var new_row: DialogColorRow = create_color_variable(
				color_row, true )
		new_row.set_value_ui( nDatabase.colors_list[ color_row ] )


func populate_speakers_in_manager() -> void:
	for speaker_row in nDatabase.speakers_list.keys():
		var new_row: DialogSpeakerRow = create_speaker_variable(
				speaker_row, true )
		new_row.set_value_ui( nDatabase.speakers_list[ speaker_row ] )


func populate_flags_in_item_list() -> void:
	nItemListFlags.clear()
	for flag in nDatabase.flags_list:
		nItemListFlags.add_item( flag )
	nItemListFlags.sort_items_by_text()


func populate_tags_in_item_list() -> void:
	for tag in nDatabase.tags_list:
		nItemListTags.add_item( tag )
	populate_filter_menu()


func populate_file_menus() -> void:
	nFile.connect_file_menu_signals()


func _ready() -> void:
	nSignals.connect_setup_signals()
	nMenuButtonFilterTags.get_popup().hide_on_checkable_item_selection = false
	populate_filter_menu()
	nDatabase.get_node( "DialogNodes" ).set_references()


""" Cleanup and Removal """


func clear_database_ui() -> void:
	for child in nVBCStrings.get_children():
		delete_string_variable( child )
	for child in nVBCFloats.get_children():
		delete_float_variable( child )
	for child in nVBCColors.get_children():
		delete_color_variable( child )
	for child in nVBCSpeakers.get_children():
		delete_speaker_variable( child )
	nItemListTags.clear()
	nItemListFlags.clear()
	nItemListArrays.clear()
	populate_filter_menu()
	for record_row in nVBCDialogRecords.get_children():
		nSignals.disconnect_record_signals( record_row )
		record_row.destroy()
	set_filename_label_modified( false )
	checked_records.clear()
	nLabelFileName.text = "New Database"


func destroy() -> void:
	nFile.destroy()
	nDatabase.clear_database()
	clear_database_ui()
	nSignals.disconnect_setup_signals()
