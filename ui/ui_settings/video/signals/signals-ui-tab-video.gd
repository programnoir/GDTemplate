extends Node


func _on_check_button_borderless_toggled( button_pressed: bool ) -> void:
	GlobalUserSettings.toggle_borderless( button_pressed )
	GlobalUserSettings.save_settings()


func _on_check_button_fullscreen_toggled( button_pressed: bool ) -> void:
	GlobalUserSettings.toggle_fullscreen( button_pressed )
	owner.nTabVideo.nCheckButtonBorderless.disabled = button_pressed
	owner.nTabVideo.set_game_scale( GlobalUserSettings.get_game_scale() )
	GlobalUserSettings.save_settings()


func _on_button_window_scale_down_pressed() -> void:
	owner.nTabVideo.set_window_scale( GlobalUserSettings.get_window_scale() - 1 )
	GlobalUserSettings.save_settings()


func _on_button_window_scale_up_pressed() -> void:
	owner.nTabVideo.set_window_scale( GlobalUserSettings.get_window_scale() + 1 )
	GlobalUserSettings.save_settings()


func _on_button_game_scale_down_pressed() -> void:
	owner.nTabVideo.set_game_scale( GlobalUserSettings.get_game_scale() - 1 )
	GlobalUserSettings.save_settings()


func _on_button_game_scale_up_pressed() -> void:
	owner.nTabVideo.set_game_scale( GlobalUserSettings.get_game_scale() + 1 )
	GlobalUserSettings.save_settings()
