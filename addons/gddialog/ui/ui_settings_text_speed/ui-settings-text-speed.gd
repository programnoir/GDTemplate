extends HBoxContainer

@onready var nHSliderTextSpeedScale: HSlider = get_node(
		"HSliderTextSpeedScale" )
@onready var nLabelTextSpeedScale: Label = get_node( 
		"LabelTextSpeedScale" )


func set_text_speed( new_speed: float ) -> void:
	GlobalUserSettings.accessibility[ "text_speed" ] = new_speed
	nHSliderTextSpeedScale.value = new_speed
	nLabelTextSpeedScale.text = str( "%.02f" % new_speed ) + 'x'
	GlobalUserSettings.save_settings()


func _ready() -> void:
	if( GlobalUserSettings.accessibility.has( "text_speed" ) == false ):
		set_text_speed( 1.0 )
		return
	#	End defensive return: First time setup.
	set_text_speed( GlobalUserSettings.accessibility[ "text_speed" ] )
