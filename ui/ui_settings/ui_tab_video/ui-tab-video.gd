extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nCheckButtonBorderless: CheckButton = get_node(
		"CheckButtonBorderless" )
@onready var nCheckButtonFullScreen: CheckButton = get_node(
		"CheckButtonFullscreen" )
@onready var nLabelWindowScale: Label = get_node(
		"HBCWindowScale/LabelWindowScale" )
@onready var nLabelGameScale: Label = get_node(
		"HBCGameScale/LabelGameScale" )


func add_plugin_setting( new_setting: Control ) -> void:
	add_child( new_setting )


func set_game_scale( new_scale: int ) -> void:
	GlobalUserSettings.set_game_scale( new_scale )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )
	owner.nTabAccessibility.set_font_size(
			GlobalUserSettings.get_current_font_size() )


func set_window_scale( new_scale: int ) -> void:
	GlobalUserSettings.set_window_scale( new_scale )
	if( GlobalUserSettings.get_window_scale() == GlobalUserSettings.max_scale ):
		nCheckButtonFullScreen.button_pressed = true
		nCheckButtonBorderless.disabled = true
	else:
		nCheckButtonFullScreen.button_pressed = false
		nCheckButtonBorderless.disabled = false
	#	Update information to player.
	nLabelWindowScale.text = String.num( GlobalUserSettings.get_window_scale() )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )


func toggle_fullscreen( fullscreen: bool ) -> void:
	GlobalUserSettings.toggle_fullscreen( fullscreen )
	nCheckButtonFullScreen.button_pressed = fullscreen
	nCheckButtonBorderless.disabled = fullscreen


func update_from_load() -> void:
	var temp_fullscreen: bool = GlobalUserSettings.is_fullscreen()
	var temp_borderless: bool = GlobalUserSettings.is_borderless()
	var temp_game_scale: int = GlobalUserSettings.get_game_scale()
	#	The set_window_scale() function affects fullscreen and game scale.
	GlobalUserSettings.set_window_scale( GlobalUserSettings.get_window_scale() )
	nCheckButtonBorderless.button_pressed = temp_borderless
	if( temp_fullscreen == false ):
		GlobalUserSettings.toggle_borderless( temp_borderless )
	toggle_fullscreen( temp_fullscreen )
	GlobalUserSettings.set_game_scale( temp_game_scale )
	#	Update information to player.
	nLabelWindowScale.text = String.num( GlobalUserSettings.get_window_scale() )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )


func _ready() -> void:
	GlobalUserSettings.get_display_info()
