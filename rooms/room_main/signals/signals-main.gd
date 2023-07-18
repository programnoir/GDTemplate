extends Node


func _notification( what ) -> void:
	if( what == Window.NOTIFICATION_WM_CLOSE_REQUEST ):
		print( "Force close detected. Destroying." )
		owner.destroy()


func _on_scene_change( new_scene: String ) -> void:
	var game_contents: Array = owner.nGame.get_children()
	for content in game_contents:
		content.destroy()
	GlobalUIScreenFade.set_state( GlobalUIScreenFade.FADE_OUT )
	await GlobalUIScreenFade.fade_complete
	#	TODO: Convert to loading screen.
	owner.nGame.add_child( load( new_scene ).instantiate() )
	owner.nUI.visible = false
	GlobalUIScreenFade.set_state( GlobalUIScreenFade.FADE_IN )


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


"""
	Signal management
"""


func connect_main_menu_signals() -> void:
	#	New Game
	owner.nUIMainMenu.menu_new_game.connect(
			Callable( self, "_on_menu_new_game" ) )
	#	Continue Game
	pass
	#	Settings
	owner.nUIMainMenu.menu_settings.connect(
			Callable( self, "_on_menu_settings" ) )
	#	Quit
	owner.nUIMainMenu.menu_quit.connect( Callable( self, "_on_menu_quit" ) )


func connect_settings_signals() -> void:
	owner.nUISettings.new_language.connect(
			Callable( self, "_on_new_language" ) )
	owner.nUISettings.menu_settings_closed.connect(
			Callable( self, "_on_menu_settings_closed" ) )


func disconnect_main_menu_signals() -> void:
	owner.nUIMainMenu.menu_new_game.disconnect(
			Callable( self, "_on_menu_new_game" ) )
	owner.nUIMainMenu.menu_settings.disconnect( 
			Callable( self, "_on_menu_settings" ) )
	owner.nUIMainMenu.menu_quit.disconnect( Callable( self, "_on_menu_quit" ) )


func disconnect_settings_signals() -> void:
	owner.nUISettings.new_language.disconnect(
				Callable( self, "_on_new_language" ) )
	owner.nUISettings.menu_settings_closed.disconnect(
				Callable( self, "_on_menu_settings_closed" ) )


func connect_first_setup_signals() -> void:
	owner.nUIFirstSetup.new_language.connect(
			Callable( self, "_on_new_language" ) )
	owner.nUIFirstSetup.completed_first_setup.connect(
			Callable( self, "_on_completed_first_setup" ) )


func disconnect_first_setup_signals() -> void:
	owner.nUIFirstSetup.completed_first_setup.disconnect(
			Callable( self, "_on_completed_first_setup" ) )
	owner.nUIFirstSetup.new_language.disconnect(
			Callable( self, "_on_new_language" ) )


func _on_completed_first_setup() -> void:
	disconnect_first_setup_signals()
	owner.nUIFirstSetup.destroy()
	owner.nUIFirstSetup = null
	owner.add_main_menus()


func _on_menu_quit() -> void:
	owner.destroy()
