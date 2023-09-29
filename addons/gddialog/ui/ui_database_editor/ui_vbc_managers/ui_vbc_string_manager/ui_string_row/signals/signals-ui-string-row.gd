@tool
extends Node


func _on_line_edit_string_name_focus_entered() -> void:
	owner.last_saved_name = owner.nLineEditStringName.text


func _on_line_edit_string_name_focus_exited() -> void:
	var new_text: String = owner.nLineEditStringName.text
	owner.change_name( new_text )


func _on_line_edit_string_name_text_submitted( new_text: String ) -> void:
	owner.nLineEditStringName.release_focus()


func _on_line_edit_default_value_text_submitted( new_text: String ) -> void:
	owner.emit_signal( "value_modified", owner.nLineEditStringName.text,
			new_text )


func _on_button_delete_string_pressed() -> void:
	owner.emit_signal( "destroyed", owner )


func _on_line_edit_default_value_focus_entered() -> void:
	owner.last_saved_value = owner.nLineEditDefaultValue.text


func _on_line_edit_default_value_focus_exited():
	var new_value: String = owner.nLineEditDefaultValue.text
	if( new_value == owner.last_saved_value ):
		return
	#	End defensive return: No change
	_on_line_edit_default_value_text_submitted( new_value )
