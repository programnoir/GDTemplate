extends VBoxContainer

@onready var cSig: Node = get_node( "cSig" )
@onready var nUICheckButtonFullScreen: CheckButton = get_node(
		"UICheckButtonFullscreen")
@onready var nUILabelWindowScale: Label = get_node(
		"HBCWindowScale/UILabelWindowScale" )
@onready var nUILabelGameScale: Label = get_node(
		"HBCGameScale/UILabelGameScale" )

@export var initial_fullscreen: bool = false
@export var initial_window_scale: int = 1
@export var initial_game_scale: int = 1


func set_game_scale( new_scale: int ) -> void:
	UserSettings.set_game_scale( new_scale )
	nUILabelGameScale.text = String.num( UserSettings.get_game_scale() )


func set_window_scale( new_scale: int ) -> void:
	UserSettings.set_window_scale( new_scale )
	if( UserSettings.get_window_scale() == UserSettings.max_scale ):
		nUICheckButtonFullScreen.button_pressed = true
	else:
		nUICheckButtonFullScreen.button_pressed = false
	nUILabelWindowScale.text = String.num( new_scale )
	#	Need to update info on this end, as well.
	nUILabelGameScale.text = String.num( UserSettings.get_game_scale() )


func toggle_fullscreen( fullscreen: bool ) -> void:
	UserSettings.toggle_fullscreen( fullscreen )
	nUICheckButtonFullScreen.button_pressed = fullscreen


func update_from_load() -> void:
	var temp_fullscreen: bool = UserSettings.is_fullscreen()
	var temp_game_scale: int = UserSettings.get_game_scale()
	#	The set_window_scale() function affects fullscreen and game scale.
	UserSettings.set_window_scale( UserSettings.get_window_scale() )
	toggle_fullscreen( temp_fullscreen )
	UserSettings.set_game_scale( temp_game_scale )
	nUILabelWindowScale.text = String.num( UserSettings.get_window_scale() )
	nUILabelGameScale.text = String.num( UserSettings.get_game_scale() )
	#	Handle fullscreen


func initialize_video_settings() -> void:
	print( "Initializing video" )
	UserSettings.video[ "fullscreen" ] = initial_fullscreen
	UserSettings.video[ "window_scale" ] = initial_window_scale
	UserSettings.video[ "game_scale" ] = initial_window_scale
	set_window_scale( initial_window_scale )
	toggle_fullscreen( initial_fullscreen )
	set_game_scale( initial_game_scale )


func _ready() -> void:
	UserSettings.get_display_info()
