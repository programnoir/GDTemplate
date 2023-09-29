@tool
extends Node


func _on_line_edit_array_name_text_submitted( new_text: String ) -> void:
	get_parent().add_array_to_arrays_list( new_text )


func _on_button_add_array_pressed() -> void:
	get_parent().add_array_to_arrays_list(
			get_parent().nLineEditArrayName.text )


func _on_button_delete_arrays_pressed() -> void:
	get_parent().remove_selected_arrays_from_arrays_list()
