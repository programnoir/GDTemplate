extends Node


func _notification( what ) -> void:
	if( what == Window.NOTIFICATION_WM_CLOSE_REQUEST ):
		print( "Force close detected. Destroying." )
		owner.destroy()


func _on_scene_change( new_scene: String ) -> void:
	var game_contents: Array = owner.nGame.get_children()
	for content in game_contents:
		content.destroy()
	GlobalUIScreenFade.set_state( GlobalUIScreenFade.IN )
	await GlobalUIScreenFade.fade_complete
	#	TODO: Convert to loading screen.
	owner.nGame.add_child( load( new_scene ).instantiate() )
	owner.nUI.visible = false
	GlobalUIScreenFade.set_state( GlobalUIScreenFade.FADE_OUT )


func _on_menu_new_game( first_room: String ) -> void:
	_on_scene_change( first_room )


func _on_menu_settings( previous_menu: Control ) -> void:
	owner.previous_menu = previous_menu
	owner.nUISettings.visible = true
	owner.nUISettings.menu_focus()


func _on_menu_settings_closed() -> void:
	owner.nUISettings.visible = false
	owner.previous_menu.visible = true


#	New language chosen from settings menu.
func _on_new_language( language_code: String ) -> void:
	GlobalUserSettings.set_new_language( language_code )
	GlobalUserSettings.save_settings()


func _on_menu_quit() -> void:
	owner.destroy()
