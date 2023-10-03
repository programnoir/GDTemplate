extends Node


func _notification( what ) -> void:
	if( what == Window.NOTIFICATION_WM_CLOSE_REQUEST ):
		print( "Force close detected. Destroying." )
		owner.destroy()


func _on_trigger_button_pressed() -> void:
	owner.play_dialog( "example" )


func _on_timer_typewriter_timeout() -> void:
	match owner.node_type:
		"Line":
			owner.nDialogNodes.process_simple_text()
		"Advanced":
			owner.nDialogNodes.process_current_keyframe()


func _on_timer_delay_timeout() -> void:
	match owner.node_type:
		"Advanced":
			owner.nDialogNodes.process_current_keyframe()


func _on_button_next_pressed() -> void:
	if( owner.is_playing == true ):
		return
	#	End defensive return: Prevent accidental skip
	if( owner.nPanelResponses.visible == true ):
		owner.slot = owner.nPanelResponses.get_slot()
		owner.nPanelResponses.disable()
	owner.process_next_node()

