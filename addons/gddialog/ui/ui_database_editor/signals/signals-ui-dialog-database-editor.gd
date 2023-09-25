@tool
extends Node


""" Main Interface """


func _on_menu_button_file_id_pressed( id: int ) -> void:
	match id:
		0:
			owner.nFile.menu_new_database()
		1:
			owner.nFile.menu_load_database()
		2:
			owner.nFile.menu_save_database_as()
		3:
			owner.nFile.menu_bake_database_file()


func _on_menu_button_edit_id_pressed( id: int ) -> void:
	match id:
		0:
			owner.create_dialog_record()
		1:
			owner.set_checked_all_visible_records( true )
		2:
			owner.set_checked_all_visible_records( false )
		3:
			owner.delete_checked_visible_dialogs()


func _on_menu_button_view_id_pressed( id: int ) -> void:
	owner.nPanelWorkspace.visible = ( id == 0 )
	owner.nHBCFilters.visible = ( id == 0 )
	owner.nVBCManagers.set_visible_manager( id )


func _on_button_close_sidebar_pressed() -> void:
	owner.nPanelWorkspace.visible = true
	owner.nVBCManagers.visible = false
	owner.nHBCFilters.visible = true





""" Record Operations """


#	Located in ../ui_record_row/ui-record-row.gd
func _on_editing_record( record_id: int ) -> void:
	owner.dialog_editor_choose_record( record_id )
	owner.emit_signal( "switch_control" )


func _on_record_check_toggle( record: DialogRecordRow, checked: bool ) -> void:
	owner.toggle_record_checked( record, checked )


func _on_record_rename(
		record: DialogRecordRow,
		old_name: String,
		new_name: String
) -> void:
	owner.set_current_modified_record( record )
	var record_id: int = record.get_record_id()
	owner.nDatabase.set_record_name( record_id, old_name, new_name )


func _on_record_change_description(
		record_id: int,
		new_text: String
) -> void:
	owner.nDatabase.set_record_description( record_id, new_text )


""" Record signals """


func connect_record_signals( record: DialogRecordRow ) -> void:
	record.connect( "edit_record", Callable( self, "_on_editing_record" ) )
	record.connect( "toggle_checked_record", Callable( self,
			"_on_record_check_toggle" ) )
	record.connect( "renamed_record", Callable( self, "_on_record_rename" ) )
	record.connect( "changed_record_description", Callable( self,
			"_on_record_change_description" ) )


func disconnect_record_signals( record: DialogRecordRow ) -> void:
	record.disconnect( "edit_record", Callable( self, "_on_editing_record" ) )
	record.disconnect( "toggle_checked_record", Callable( self,
			"_on_record_check_toggle" ) )
	record.disconnect( "renamed_record", Callable( self, "_on_record_rename" ) )
	record.disconnect( "changed_record_description", Callable( self,
			"_on_record_change_description" ) )


func connect_setup_signals() -> void:
	owner.nMenuButtonFile.get_popup().connect( "id_pressed", Callable(
			self, "_on_menu_button_file_id_pressed" ) )
	owner.nMenuButtonEdit.get_popup().connect( "id_pressed", Callable(
			self, "_on_menu_button_edit_id_pressed" ) )
	owner.nMenuButtonView.get_popup().connect( "id_pressed", Callable(
			self, "_on_menu_button_view_id_pressed" ) )


func disconnect_setup_signals() -> void:
	owner.nMenuButtonFile.get_popup().disconnect( "id_pressed", Callable(
			self, "_on_menu_button_file_id_pressed" ) )
	owner.nMenuButtonEdit.get_popup().disconnect( "id_pressed", Callable(
			self, "_on_menu_button_edit_id_pressed" ) )
	owner.nMenuButtonView.get_popup().disconnect( "id_pressed", Callable(
			self, "_on_menu_button_view_id_pressed" ) )
