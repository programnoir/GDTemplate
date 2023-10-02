extends Node


func _notification( what ) -> void:
	if( what == Window.NOTIFICATION_WM_CLOSE_REQUEST ):
		print( "Force close detected. Destroying." )
		owner.destroy()


func _on_trigger_button_pressed() -> void:
	owner.play_dialog( "example" )
