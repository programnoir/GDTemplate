extends HSlider
class_name HSliderVolume
## A specialized volume slider that is associated with audio busses.
"""
Notes:
	No notes.
Debug Info:
	No debug info.
"""

##	Selects which bus to assign the volume slider to. Default is Premaster.
@export_enum( "Premaster:1", "Music:2", "SFX:3", "Voice:4" ) var BUS_ID: int = 1


func _on_value_changed( new_value: float ) -> void:
	GlobalUserSettings.set_bus_volume( BUS_ID, new_value )
	GlobalUserSettings.save_settings()
