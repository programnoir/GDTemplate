extends Node


func _on_ui_check_button_fullscreen_toggled( button_pressed: bool ) -> void:
	#	Set the Game Window to fullscreen.
	UserSettings.toggle_fullscreen( button_pressed )
	owner.nUITabVideo.set_game_scale( UserSettings.get_game_scale() )
	UserSettings.save_settings()


func _on_ui_button_window_scale_down_pressed() -> void:
	owner.nUITabVideo.set_window_scale( UserSettings.get_window_scale() - 1 )
	UserSettings.save_settings()


func _on_ui_button_window_scale_up_pressed() -> void:
	owner.nUITabVideo.set_window_scale( UserSettings.get_window_scale() + 1 )
	UserSettings.save_settings()


func _on_ui_button_reduce_scale_pressed() -> void:
	owner.nUITabVideo.set_game_scale( UserSettings.get_game_scale() - 1 )
	UserSettings.save_settings()


func _on_ui_button_increase_scale_pressed() -> void:
	owner.nUITabVideo.set_game_scale( UserSettings.get_game_scale() + 1 )
	UserSettings.save_settings()
