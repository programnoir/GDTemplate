extends HSlider
class_name HSliderVolume

#	By default, set the bus ID to the Premaster.
@export_enum( "Premaster:1", "Music:2", "SFX:3", "Voice:4" ) var bus_id: int = 1


func _on_value_changed( new_value: float ) -> void:
	UserSettings.set_bus_volume( bus_id, new_value )
	UserSettings.save_settings()
