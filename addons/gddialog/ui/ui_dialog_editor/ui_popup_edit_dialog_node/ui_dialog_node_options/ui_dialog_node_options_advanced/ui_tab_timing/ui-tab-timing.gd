@tool
extends VBoxContainer

@onready var nSpinBoxDelay: SpinBox = get_node(
		"VBoxContainer/HBoxContainer/SpinBoxDelay" )
@onready var nCheckBoxFixedDelay: CheckBox = get_node(
		"VBoxContainer/HBoxContainer/CheckBoxFixedDelay" )
@onready var nSpinBoxWriteSpeed: SpinBox = get_node(
		"VBoxContainer/HBoxContainer2/SpinBoxWriteSpeed" )
@onready var nCheckBoxFixedWriteSpeed: CheckBox = get_node(
		"VBoxContainer/HBoxContainer2/CheckBoxFixedWriteSpeed" )


func save_current_keyframe( data: Dictionary ) -> void:
	data[ "ignore_player_speed_delay" ] = nCheckBoxFixedDelay.button_pressed
	data[ "ignore_player_speed_write" ] = \
			nCheckBoxFixedWriteSpeed.button_pressed
	data[ "timer_delay" ] = nSpinBoxDelay.value
	data[ "write_speed" ] = nSpinBoxWriteSpeed.value


func load_current_keyframe() -> void:
	nCheckBoxFixedDelay.button_pressed = owner.get_keyframe_property(
			"ignore_player_speed_delay" )
	nCheckBoxFixedWriteSpeed.button_pressed = owner.get_keyframe_property(
			"ignore_player_speed_write" )
	nSpinBoxDelay.value = owner.get_keyframe_property( "timer_delay" )
	nSpinBoxWriteSpeed.value = owner.get_keyframe_property( "write_speed" )
