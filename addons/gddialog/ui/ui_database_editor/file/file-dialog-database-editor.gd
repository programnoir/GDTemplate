@tool
extends Node

var file_dialog_load_database: EditorFileDialog
var file_dialog_save_database: EditorFileDialog
var file_dialog_bake_database: EditorFileDialog


""" Signals """


func _on_file_dialog_load_database_file_selected( filename: String ) -> void:
	var file_data = load( filename )
	if not file_data.TYPE == "dialog_database":
		print( "Loaded file %s is of wrong filetype." % filename )
		return
	owner.set_filename_label_modified( false )
	owner.nDatabase.clear_database()
	owner.clear_database_ui()
	#	See res://addons/resources/res-dialog-database.gd
	owner.nDatabase.database = file_data.database.duplicate( true )
	owner.nDatabase.available_record_ids = \
			file_data.available_record_ids.duplicate( true )
	owner.nDatabase.flags_list = file_data.flags_list.duplicate( true )
	owner.nDatabase.strings_list = file_data.strings_list.duplicate( true )
	owner.nDatabase.floats_list = file_data.floats_list.duplicate( true )
	owner.nDatabase.colors_list = file_data.colors_list.duplicate( true )
	owner.nDatabase.speakers_list = file_data.speakers_list.duplicate( true )
	owner.nDatabase.string_arrays_list = file_data.string_arrays_list\
			.duplicate( true )
	owner.nDatabase.tags_list = file_data.tags_list.duplicate( true )
	owner.nDatabase.record_names = file_data.record_names.duplicate( true )
	owner.nDatabase.keyframe_flag_list = \
			file_data.keyframe_flag_list.duplicate( true )
	owner.nLabelFileName.text = str( filename.get_file() )
	owner.populate_arrays_in_item_list()
	owner.populate_colors_in_manager()
	owner.populate_flags_in_item_list()
	owner.populate_floats_in_manager()
	owner.populate_speakers_in_manager()
	owner.populate_strings_in_manager()
	owner.populate_tags_in_item_list()
	for id in owner.nDatabase.database.keys():
		var new_record = owner.p_UIRecordRow.instantiate()
		owner.nVBCDialogRecords.add_child( new_record )
		new_record.set_record_id( id )
		var description: String = owner.nDatabase.get_record_description( id )
		new_record.set_record_description( description )
		if( owner.nDatabase.database[ id ].has( "name" ) ):
			var record_name = owner.nDatabase.database[ id ][ "name" ]
			new_record.set_record_name_field( record_name )
		for tag_name in owner.nDatabase.database[ id ][ "tags" ]:
			new_record.add_tag_to_tag_list( tag_name )
		owner.nSignals.connect_record_signals( new_record )
	owner.nDatabase.nDialogNodes.set_references()


func _on_file_dialog_save_database_file_selected( filename: String ) -> void:
	var file_data: = DialogDatabase.new()
	#	If the file exists, try to overwrite it.
	if( FileAccess.file_exists( filename ) ):
		file_data = load( filename )
		#	See res://addons/resources/res-dialog-database.gd
		if( file_data.TYPE != "dialog_database" ):
			print( "Existing file %s is of incorrect filetype." % filename )
			return
	#	End defensive return: Gathering file data or overwriting wrong type.
	owner.set_filename_label_modified( false )
	file_data.database = owner.nDatabase.database.duplicate( true )
	file_data.record_names = owner.nDatabase.record_names.duplicate( true )
	file_data.colors_list = owner.nDatabase.colors_list.duplicate( true )
	file_data.flags_list = owner.nDatabase.flags_list.duplicate( true )
	file_data.floats_list = owner.nDatabase.floats_list.duplicate( true )
	file_data.speakers_list = owner.nDatabase.speakers_list.duplicate( true )
	file_data.strings_list = owner.nDatabase.strings_list.duplicate( true )
	file_data.string_arrays_list = owner.nDatabase.string_arrays_list\
			.duplicate( true )
	file_data.tags_list = owner.nDatabase.tags_list.duplicate( true )
	file_data.available_record_ids = owner.nDatabase.available_record_ids\
			.duplicate( true )
	file_data.keyframe_flag_list = \
			owner.nDatabase.keyframe_flag_list.duplicate( true )
	ResourceSaver.save( file_data, filename )
	owner.nLabelFileName.text = filename.get_file()


func _on_file_dialog_bake_database_file_selected( filename: String ) -> void:
	var file_data: = DialogDatabaseBaked.new()
	#	If the file exists, try to overwrite it.
	if FileAccess.file_exists( filename ):
		file_data = load( filename )
		if file_data.TYPE != "baked_dialog_database":
			print( "Existing file %s is of incorrect filetype." % filename )
			return
		#	End defensive return: Wrong filetype.
	#	Important data only.
	file_data.database = bake_data()
	file_data.record_names = owner.nDatabase.record_names.duplicate( true )
	file_data.colors_list = owner.nDatabase.colors_list.duplicate( true )
	file_data.flags_list = owner.nDatabase.flags_list.duplicate( true )
	file_data.floats_list = owner.nDatabase.floats_list.duplicate( true )
	file_data.speakers_list = owner.nDatabase.speakers_list.duplicate( true )
	file_data.strings_list = owner.nDatabase.strings_list.duplicate( true )
	file_data.string_arrays_list = owner.nDatabase.string_arrays_list\
			.duplicate( true )
	ResourceSaver.save( file_data, filename )


func menu_new_database() -> void:
	owner.set_filename_label_modified( false )
	owner.nDatabase.clear_database()
	owner.clear_database_ui()
	owner.nLabelFileName.text = "New Database"


func menu_load_database() -> void:
	file_dialog_load_database.popup_centered_ratio( 0.7 )


func menu_save_database_as() -> void:
	file_dialog_save_database.popup_centered_ratio( 0.7 )


func menu_bake_database_file() -> void:
	file_dialog_bake_database.popup_centered_ratio( 0.7 )


""" Functions """


""" Initializes the file operation """
func init_file_operation_dialogs():
	file_dialog_load_database = EditorFileDialog.new()
	file_dialog_load_database.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog_load_database.add_filter( "*.tres ; Dialog databases" )
	file_dialog_load_database.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog_load_database.current_dir = "res://addons/gddialog/data"
	
	file_dialog_save_database = EditorFileDialog.new()
	file_dialog_save_database.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog_save_database.add_filter( "*.tres ; Dialog databases" )
	file_dialog_save_database.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog_save_database.current_dir = "res://addons/gddialog/data"
	
	file_dialog_bake_database = EditorFileDialog.new()
	file_dialog_bake_database.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog_bake_database.add_filter( 
			"*.tres ; Baked Dialog databases" )
	file_dialog_bake_database.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog_bake_database.current_dir = "res://addons/gddialog/data/baked"


func bake_data() :
	var baked_db = owner.nDatabase.database.duplicate( true )
	for id in baked_db.keys():
		#	These are unnecessary in a baked database.
		baked_db[ id ].erase( "name" )
		baked_db[ id ].erase( "tags" )
		baked_db[ id ].erase( "available_node_ids" )
		baked_db[ id ].erase( "description" )
		#	
		for node_id in baked_db[ id ][ "nodes" ].keys():
			#	Actually this one might be useful.
			#baked_db[ id ][ "nodes" ][ node_id ].erase( "type" )
			#	These aren't.
			baked_db[ id ][ "nodes" ][ node_id ].erase( "graph_offset" )
			baked_db[ id ][ "nodes" ][ node_id ].erase( "rect_size" )
			baked_db[ id ][ "nodes" ][ node_id ].erase( "slot_amount" )
	return baked_db.duplicate( true )


func connect_file_menu_signals() -> void:
	file_dialog_load_database.connect( "file_selected", Callable( self,
			"_on_file_dialog_load_database_file_selected" ) )
	file_dialog_save_database.connect( "file_selected", Callable( self,
			"_on_file_dialog_save_database_file_selected" ) )
	file_dialog_bake_database.connect( "file_selected", Callable( self,
			"_on_file_dialog_bake_database_file_selected" ) )


func _ready():
	init_file_operation_dialogs()
	owner.call_deferred( "add_child", file_dialog_load_database )
	owner.call_deferred( "add_child", file_dialog_save_database )
	owner.call_deferred( "add_child", file_dialog_bake_database )
	owner.call_deferred( "populate_file_menus" )


func destroy() -> void:
	file_dialog_load_database.disconnect( "file_selected", Callable( self,
			"_on_file_dialog_load_database_file_selected" ) )
	file_dialog_save_database.disconnect( "file_selected", Callable( self,
			"_on_file_dialog_save_database_file_selected" ) )
	file_dialog_bake_database.disconnect( "file_selected", Callable( self,
			"_on_file_dialog_bake_database_file_selected" ) )
	file_dialog_load_database.queue_free()
	file_dialog_save_database.queue_free()
	file_dialog_bake_database.queue_free()
	owner.nMenuButtonFile.get_popup().clear()
	queue_free()
