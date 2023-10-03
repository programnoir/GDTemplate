extends Node


func _unhandled_input( event: InputEvent ) -> void:
	if( get_parent().visible == false ):
		return
	#	End defensive return: Not visible.
	if( Input.is_action_just_pressed( "ui_left" ) ):
		get_parent().update_responses( -1 )
	elif( Input.is_action_just_pressed( "ui_right" ) ):
		get_parent().update_responses( 1 )


func _on_button_previous_response_pressed() -> void:
	get_parent().update_responses( -1 )


func _on_button_next_response_pressed() -> void:
	get_parent().update_responses( 1 )
