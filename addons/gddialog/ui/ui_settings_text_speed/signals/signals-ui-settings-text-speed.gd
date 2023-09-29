extends Node


func _on_h_slider_text_speed_scale_value_changed( value: float ) -> void:
	owner.set_text_speed( value )
