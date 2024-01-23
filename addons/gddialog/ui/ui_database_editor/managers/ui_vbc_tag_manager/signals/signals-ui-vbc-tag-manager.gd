@tool
extends Node


func _on_line_edit_new_tag_text_submitted( new_text: String ) -> void:
	get_parent().add_tag_to_tags_list( new_text )


func _on_button_add_tag_pressed() -> void:
	get_parent().add_tag_to_tags_list( get_parent().nLineEditNewTag.text )


func _on_button_assign_tag_pressed() -> void:
	get_parent().manage_tags_on_checked_records( true )


func _on_button_unassign_tag_pressed() -> void:
	get_parent().manage_tags_on_checked_records( false )


func _on_button_delete_tag_pressed() -> void:
	get_parent().manage_tags_on_checked_records( false, true )
