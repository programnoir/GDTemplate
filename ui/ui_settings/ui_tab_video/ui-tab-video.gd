extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nCheckButtonFullScreen: CheckButton = get_node(
		"CheckButtonFullscreen")
@onready var nLabelWindowScale: Label = get_node(
		"HBCWindowScale/LabelWindowScale" )
@onready var nLabelGameScale: Label = get_node(
		"HBCGameScale/LabelGameScale" )

@export var initial_fullscreen: bool = false
@export var initial_window_scale: int = 1
@export var initial_game_scale: int = 1


func set_game_scale( new_scale: int ) -> void:
	GlobalUserSettings.set_game_scale( new_scale )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )


func set_window_scale( new_scale: int ) -> void:
	GlobalUserSettings.set_window_scale( new_scale )
	if( GlobalUserSettings.get_window_scale() == GlobalUserSettings.max_scale ):
		nCheckButtonFullScreen.button_pressed = true
	else:
		nCheckButtonFullScreen.button_pressed = false
	#	Update information to player.
	nLabelWindowScale.text = String.num( new_scale )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )


func toggle_fullscreen( fullscreen: bool ) -> void:
	GlobalUserSettings.toggle_fullscreen( fullscreen )
	nCheckButtonFullScreen.button_pressed = fullscreen


func update_from_load() -> void:
	var temp_fullscreen: bool = GlobalUserSettings.is_fullscreen()
	var temp_game_scale: int = GlobalUserSettings.get_game_scale()
	#	The set_window_scale() function affects fullscreen and game scale.
	GlobalUserSettings.set_window_scale( GlobalUserSettings.get_window_scale() )
	toggle_fullscreen( temp_fullscreen )
	GlobalUserSettings.set_game_scale( temp_game_scale )
	#	Update information to player.
	nLabelWindowScale.text = String.num( GlobalUserSettings.get_window_scale() )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )


func initialize_video_settings() -> void:
	print( "Initializing video" )
	GlobalUserSettings.video[ "fullscreen" ] = initial_fullscreen
	GlobalUserSettings.video[ "window_scale" ] = initial_window_scale
	GlobalUserSettings.video[ "game_scale" ] = initial_window_scale
	set_window_scale( initial_window_scale )
	toggle_fullscreen( initial_fullscreen )
	set_game_scale( initial_game_scale )


func _ready() -> void:
	GlobalUserSettings.get_display_info()
