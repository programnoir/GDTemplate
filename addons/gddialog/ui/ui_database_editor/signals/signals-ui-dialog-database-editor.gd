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
	owner.nVBCManagers.visible = true
	owner.nPanelWorkspace.visible = ( id == 0 )
	owner.nHBCFilters.visible = ( id == 0 )
	owner.nVBCTagManager.visible = ( id == 0 )
	#	Now for the other managers
	owner.nVBCFlagManager.visible = ( id == 2 )
	owner.nVBCFloatManager.visible = ( id == 3 )
	owner.nVBCStringManager.visible = ( id == 4 )
	owner.nVBCArrayManager.visible = ( id == 5 )
	owner.nVBCColorManager.visible = ( id == 7 )
	owner.nVBCSpeakerManager.visible = ( id == 8 )
	match id:
		0:
			owner.nLabelManagerTitle.text = "Tag Manager"
		2:
			owner.nLabelManagerTitle.text = "Flag Manager"
		3:
			owner.nLabelManagerTitle.text = "Float Manager"
		4:
			owner.nLabelManagerTitle.text = "String Manager"
		5:
			owner.nLabelManagerTitle.text = "Array Manager"
		7:
			owner.nLabelManagerTitle.text = "Color Manager"
		8:
			owner.nLabelManagerTitle.text = "Speaker Manager"


func _on_button_close_sidebar_pressed() -> void:
	owner.nPanelWorkspace.visible = true
	owner.nVBCManagers.visible = false
	owner.nHBCFilters.visible = true


func _on_option_button_search_by_item_selected( index: int ) -> void:
	owner.update_filter()


func _on_line_edit_search_text_changed( new_text: String ) -> void:
	owner.update_filter()


func _on_check_box_tag_filter_toggled( button_pressed: bool ) -> void:
	owner.update_filter()


func _on_menu_button_filter_tags_index_pressed( tag: int ) -> void:
	var nFilterMenu: PopupMenu = owner.nMenuButtonFilterTags.get_popup()
	var checked: bool = nFilterMenu.is_item_checked( tag )
	checked = not checked
	nFilterMenu.set_item_checked( tag, checked )
	if( owner.nCheckBoxTagFilter.button_pressed == true ):
		owner.update_filter()


""" Flag Manager """


func _on_line_edit_flag_name_text_submitted( new_text: String ) -> void:
	owner.add_flag_to_flags_list( new_text )


func _on_button_add_flag_pressed() -> void:
	owner.add_flag_to_flags_list( owner.nLineEditFlagName.text )


func _on_button_delete_flags_pressed() -> void:
	owner.remove_selected_flags_from_flags_list()


""" String Array Manager """


func _on_line_edit_array_name_text_submitted( new_text: String ) -> void:
	owner.add_array_to_arrays_list( new_text )


func _on_button_add_array_pressed():
	owner.add_array_to_arrays_list( owner.nLineEditArrayName.text )


func _on_button_delete_arrays_pressed():
	owner.remove_selected_arrays_from_arrays_list()



""" String Manager """


func _on_line_edit_new_string_text_submitted( new_text: String ) -> void:
	owner.create_string_variable( new_text )


func _on_button_add_string_pressed() -> void:
	var string_name: String = owner.nLineEditNewString.text
	owner.create_string_variable( string_name )


func _on_string_name_modified(
		current_name: String,
		new_name: String,
		row: DialogStringRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_string( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_string_value_modified(
		string_name: String,
		new_value: String
) -> void:
	owner.nDatabase.set_string_default_value( string_name, new_value )


func _on_string_destroyed( row: DialogStringRow ) -> void:
	owner.delete_string_variable( row )


""" Float Manager """


func _on_button_add_float_pressed() -> void:
	var float_name: String = owner.nLineEditFloatName.text
	owner.create_float_variable( float_name )


func _on_line_edit_new_float_text_submitted( new_text: String ) -> void:
	owner.create_float_variable( new_text )


func _on_float_name_modified(
		current_name: String,
		new_name: String,
		row: DialogFloatRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_float( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_float_value_modified(
		string_name: String,
		new_value: float
) -> void:
	owner.nDatabase.set_float_default_value( string_name, new_value )


func _on_float_destroyed( row: DialogFloatRow ) -> void:
	owner.delete_float_variable( row )


""" Color Manager """


func _on_line_edit_add_color_text_submitted( new_text: String ) -> void:
	owner.create_color_variable( new_text )


func _on_button_add_color_pressed() -> void:
	owner.create_color_variable( owner.nLineEditAddColor.text )


func _on_color_name_modified(
		current_name: String,
		new_name: String,
		row: DialogColorRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_color( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_color_value_modified(
		color_name: String,
		new_value: Color
) -> void:
	owner.nDatabase.set_color_default_value( color_name, new_value )


func _on_color_destroyed( row: DialogColorRow ) -> void:
	owner.delete_color_variable( row )


""" Speaker Manager """


func _on_line_edit_add_speaker_text_submitted( new_text: String ) -> void:
	owner.create_speaker_variable( new_text )


func _on_button_add_speaker_pressed() -> void:
	owner.create_speaker_variable( owner.nLineEditAddSpeaker.text )


func _on_speaker_name_modified(
		current_name: String,
		new_name: String,
		row: DialogSpeakerRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_speaker( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_speaker_color_value_modified(
		speaker_name: String,
		new_value: Color
) -> void:
	owner.nDatabase.set_speaker_color_default_value( speaker_name, new_value )


func _on_speaker_destroyed( row: DialogSpeakerRow ) -> void:
	owner.delete_speaker_variable( row )



""" Tag Manager """


func _on_line_edit_new_tag_text_submitted( new_text: String ) -> void:
	owner.add_tag_to_tags_list( new_text )


func _on_button_add_tag_pressed() -> void:
	owner.add_tag_to_tags_list( owner.nLineEditNewTag.text )


func _on_button_assign_tag_pressed() -> void:
	owner.manage_tags_on_checked_records( true )


func _on_button_unassign_tag_pressed() -> void:
	owner.manage_tags_on_checked_records( false )


func _on_button_delete_tag_pressed() -> void:
	owner.manage_tags_on_checked_records( false, true )


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


""" Signal Management """


func connect_float_signals( row: DialogFloatRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_float_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_float_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_float_destroyed" ) )


func disconnect_float_signals( row: DialogFloatRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_float_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_float_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_float_destroyed" ) )


func connect_string_signals( row: DialogStringRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_string_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_string_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_string_destroyed" ) )


func disconnect_string_signals( row: DialogStringRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_string_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_string_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_string_destroyed" ) )


func connect_color_signals( row: DialogColorRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_color_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_color_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_color_destroyed" ) )


func disconnect_color_signals( row: DialogColorRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_color_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_color_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_color_destroyed" ) )


func connect_speaker_signals( row: DialogSpeakerRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_speaker_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_speaker_color_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_speaker_destroyed" ) )


func disconnect_speaker_signals( row: DialogSpeakerRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_speaker_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_speaker_color_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_speaker_destroyed" ) )


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
	owner.nMenuButtonFilterTags.get_popup().connect( "index_pressed",
			Callable( self, "_on_menu_button_filter_tags_index_pressed" ) )


func disconnect_setup_signals() -> void:
	owner.nMenuButtonFilterTags.get_popup().disconnect( "index_pressed",
			Callable( self, "_on_menu_button_filter_tags_index_pressed" ) )
	owner.nMenuButtonFile.get_popup().disconnect( "id_pressed", Callable(
			self, "_on_menu_button_file_id_pressed" ) )
	owner.nMenuButtonEdit.get_popup().disconnect( "id_pressed", Callable(
			self, "_on_menu_button_edit_id_pressed" ) )
	owner.nMenuButtonView.get_popup().disconnect( "id_pressed", Callable(
			self, "_on_menu_button_view_id_pressed" ) )
