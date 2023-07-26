extends Node

const PREMASTER: int = 1


"""
	Accessibility
"""


func _on_option_button_language_item_selected( index: int ) -> void:
	owner.set_language( index )


func _on_button_cycle_font_new_index( current_index: int ) -> void:
	owner.set_font( current_index )


func _on_button_font_size_up_pressed() -> void:
	owner.set_font_size( 1 )


func _on_button_font_size_down_pressed() -> void:
	owner.set_font_size( -1 )


"""
	Audio
"""


func _on_check_button_mute_toggled( button_pressed: bool ) -> void:
	#	Converts boolean value to float representation of volume.
	var new_volume: float = 1.0 - float( button_pressed )
	GlobalUserSettings.set_bus_volume( PREMASTER, 1.0 - new_volume )
	GlobalUserSettings.save_settings()


"""
	Video
"""


func _on_check_button_fullscreen_toggled( button_pressed: bool ) -> void:
	GlobalUserSettings.toggle_fullscreen( button_pressed )
	owner.set_game_scale( GlobalUserSettings.get_game_scale() )
	GlobalUserSettings.save_settings()


func _on_button_window_scale_down_pressed() -> void:
	owner.set_window_scale( GlobalUserSettings.get_window_scale() - 1 )
	GlobalUserSettings.save_settings()


func _on_button_window_scale_up_pressed() -> void:
	owner.set_window_scale( GlobalUserSettings.get_window_scale() + 1 )
	GlobalUserSettings.save_settings()


func _on_button_game_scale_down_pressed() -> void:
	owner.set_game_scale( GlobalUserSettings.get_game_scale() - 1 )
	GlobalUserSettings.save_settings()


func _on_button_game_scale_up_pressed() -> void:
	owner.set_game_scale( GlobalUserSettings.get_game_scale() + 1 )
	GlobalUserSettings.save_settings()


"""
	Confirm
"""


func _on_button_complete_setup_pressed() -> void:
	GlobalUserSettings.set_first_time_setup( true )
	GlobalUserSettings.save_settings()
	owner.emit_signal( "completed_first_setup" )


