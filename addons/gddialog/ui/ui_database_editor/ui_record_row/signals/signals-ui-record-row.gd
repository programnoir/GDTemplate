@tool
extends Node


func _unhandled_key_input( event: InputEvent ) -> void:
	if( Input.is_action_just_pressed(
			"ui_text_clear_carets_and_selection" )
	):
		if( owner.nLineEditRecordName.has_focus() ):
			owner.nLineEditRecordName.text = owner.name_backup
			owner.nLineEditRecordName.release_focus()
		elif( owner.nLineEditDescription.has_focus() ):
			owner.nLineEditDescription.text = owner.description_backup
			owner.nLineEditDescription.release_focus()


func _on_check_box_toggled( button_pressed: bool ) -> void:
	owner.emit_signal( "toggle_checked_record", owner, button_pressed )


func _on_button_edit_record_pressed() -> void:
	owner.emit_signal( "edit_record", owner.id )


func _on_line_edit_record_name_focus_entered() -> void:
	owner.name_backup = owner.nLineEditRecordName.text
	set_process_unhandled_input( true )


func _on_line_edit_record_name_focus_exited() -> void:
	if( owner.name_backup != owner.nLineEditRecordName.text ):
		owner.emit_signal( "renamed_record", owner,
				owner.name_backup, owner.nLineEditRecordName.text )
	owner.name_backup = ""
	set_process_unhandled_input( false )


func _on_line_edit_record_name_text_submitted( new_text: String ) -> void:
	owner.nLineEditRecordName.release_focus()


func _on_line_edit_description_focus_entered() -> void:
	owner.description_backup = owner.nLineEditDescription.text
	set_process_unhandled_input( true )


func _on_line_edit_description_focus_exited() -> void:
	if( owner.description_backup != owner.nLineEditDescription.text ):
		owner.emit_signal( "changed_record_description", owner.id,
				owner.nLineEditDescription.text )
	owner.description_backup = ""
	set_process_unhandled_input( false )


func _on_line_edit_description_text_submitted( new_text: String ) -> void:
	owner.nLineEditDescription.release_focus()


func _ready() -> void:
	set_process_unhandled_input( false )
