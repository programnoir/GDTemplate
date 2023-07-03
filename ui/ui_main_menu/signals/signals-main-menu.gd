extends Node


func _on_button_new_pressed():
	owner.emit_signal( "menu_new_game", owner.room_game_start )


#	Opens the settings menu.
func _on_button_settings_pressed() -> void:
	owner.focus_button = owner.nButtonSettings
	owner.visible = false
	owner.emit_signal( "menu_settings", owner )


func _on_button_quit_pressed():
	owner.emit_signal( "menu_quit" )


func _on_button_settings_visibility_changed() -> void:
	if( owner.visible == true ):
		owner.menu_focus()
