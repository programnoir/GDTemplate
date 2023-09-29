@tool
extends Node


func _on_line_edit_flag_name_text_submitted( new_text: String ) -> void:
	get_parent().add_flag_to_flags_list( new_text )


func _on_button_add_flag_pressed() -> void:
	get_parent().add_flag_to_flags_list( get_parent().nLineEditFlagName.text )


func _on_button_delete_flags_pressed() -> void:
	get_parent().remove_selected_flags_from_flags_list()
