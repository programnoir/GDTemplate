@tool
extends Node


func _on_text_edit_text_changed() -> void:
	owner.node_data[ "keyframes" ][ owner.current_keyframe ][ "text" ] = \
			owner.nTextEdit.text
	owner.update_rich_text()


func _on_button_previous_keyframe_pressed() -> void:
	owner.update_current_keyframe( -1 )


func _on_button_next_keyframe_pressed() -> void:
	owner.update_current_keyframe( 1 )


func _on_button_append_keyframe_pressed() -> void:
	owner.create_advanced_node_keyframe()
	owner.nTextEdit.grab_focus()


func _on_button_delete_keyframe_pressed() -> void:
	owner.delete_current_keyframe()


func _on_button_add_response_pressed() -> void:
	owner.add_responses( 1 )


func _on_button_remove_response_pressed() -> void:
	owner.add_responses( -1 )
