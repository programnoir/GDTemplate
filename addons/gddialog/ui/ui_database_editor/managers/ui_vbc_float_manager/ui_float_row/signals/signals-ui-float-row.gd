@tool
extends Node


func _on_line_edit_float_name_focus_entered() -> void:
	owner.last_saved_name = owner.nLineEditFloatName.text


func _on_line_edit_float_name_focus_exited() -> void:
	var new_text = owner.nLineEditFloatName.text
	owner.change_name( new_text )


func _on_line_edit_float_name_text_submitted( new_text: String ) -> void:
	owner.nLineEditFloatName.release_focus()


func _on_spin_box_default_value_value_changed( value: float ) -> void:
	owner.emit_signal( "value_modified", owner.nLineEditFloatName.text, value )


func _on_button_delete_string_pressed() -> void:
	owner.emit_signal( "destroyed", owner )


