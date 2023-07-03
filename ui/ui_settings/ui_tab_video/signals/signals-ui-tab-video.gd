extends Node


func _on_check_button_fullscreen_toggled( button_pressed: bool ) -> void:
	#	Set the Game Window to fullscreen.
	GlobalUserSettings.toggle_fullscreen( button_pressed )
	owner.nTabVideo.set_game_scale( GlobalUserSettings.get_game_scale() )
	GlobalUserSettings.save_settings()


func _on_button_window_scale_down_pressed() -> void:
	owner.nTabVideo.set_window_scale( GlobalUserSettings.get_window_scale() - 1 )
	GlobalUserSettings.save_settings()


func _on_button_window_scale_up_pressed() -> void:
	owner.nTabVideo.set_window_scale( GlobalUserSettings.get_window_scale() + 1 )
	GlobalUserSettings.save_settings()


func _on_button_reduce_scale_pressed() -> void:
	owner.nTabVideo.set_game_scale( GlobalUserSettings.get_game_scale() - 1 )
	GlobalUserSettings.save_settings()


func _on_button_increase_scale_pressed() -> void:
	owner.nTabVideo.set_game_scale( GlobalUserSettings.get_game_scale() + 1 )
	GlobalUserSettings.save_settings()