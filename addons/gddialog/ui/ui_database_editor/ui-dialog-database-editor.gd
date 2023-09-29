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
#	Search Filter Controls
@onready var nHBCFilters: HBoxContainer = get_node( "VBoxContainer"\
		+ "/HBCFilters" )

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
	for checked_record in range( array_length ):
		#	Iterating instead of popping because it may be invisible.
		var record = checked_records[ array_length - 1 - checked_record ]
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


func populate_file_menus() -> void:
	nFile.connect_file_menu_signals()


func _ready() -> void:
	nSignals.connect_setup_signals()
	nHBCFilters.populate_filter_menu()
	nDatabase.get_node( "DialogNodes" ).set_references()


""" Cleanup and Removal """


func clear_database_ui() -> void:
	nVBCManagers.clear_ui()
	nHBCFilters.populate_filter_menu()
	for record_row in nVBCDialogRecords.get_children():
		nSignals.disconnect_record_signals( record_row )
		record_row.destroy()
	set_filename_label_modified( false )
	checked_records.clear()
	nLabelFileName.text = "New Database"


func destroy() -> void:
	nFile.destroy()
	nHBCFilters.destroy()
	nDatabase.clear_database()
	clear_database_ui()
	nSignals.disconnect_setup_signals()
