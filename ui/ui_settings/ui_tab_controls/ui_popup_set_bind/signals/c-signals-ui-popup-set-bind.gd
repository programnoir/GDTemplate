extends Node


func _input( event: InputEvent ) -> void:
	if( event.is_action_type() == false or get_parent().awaiting_input == false ):
		return
	if( get_parent().current_event != null ):
		return
	get_parent().set_event( event )
	set_process_input( false )


func _on_ui_button_retry_bind_pressed() -> void:
	get_parent().read_new_bind_input( get_parent().current_action )


func _on_ui_button_cancel_bind_pressed() -> void:
	get_parent().visible = false
	#	Todo: Return focus to previous menu


func _on_ui_button_set_bind_pressed() -> void:
	var parent: PopupPanel = get_parent()
	if( parent.nUIButtonSetBind.disabled ):
		return
	parent.send_new_action_bind( parent.current_action, parent.current_event )
	parent.current_action = null
	parent.current_event = null


func _on_ui_popup_set_bind_about_to_popup():
	var parent: PopupPanel = get_parent()
	parent.nUILineEditBindName.grab_focus()
