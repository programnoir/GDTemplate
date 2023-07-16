extends Control

signal new_language
signal completed_first_setup

@onready var nSignals: Node = get_node( "Signals" )
@onready var nVBCFirstSetup: VBoxContainer = get_node(
			"Panel/SCFirstSetup/VBCFirstSetup" )
@onready var nOptionButtonLanguages: OptionButton = nVBCFirstSetup.get_node(
		"HBCLanguages/OptionButtonLanguage" )
@onready var nCheckButtonFullScreen: CheckButton = nVBCFirstSetup.get_node(
		"CheckButtonFullscreen")
@onready var nLabelWindowScale: Label = nVBCFirstSetup.get_node(
		"HBCWindowScale/LabelWindowScale" )
@onready var nLabelGameScale: Label = nVBCFirstSetup.get_node(
		"HBCGameScale/LabelGameScale" )

@export var initial_fullscreen: bool = false
@export var initial_window_scale: int = 1
@export var initial_game_scale: int = 1


func set_language( index: int ) -> void:
	var full_name: String = nOptionButtonLanguages.get_item_text(
			max( index, 0 ) )
	emit_signal( "new_language", GlobalUserSettings.languages[ full_name ] )


func populate_languages() -> void:
	for full_name in GlobalUserSettings.languages.keys():
		nOptionButtonLanguages.add_item( full_name )
	nOptionButtonLanguages.select( 0 )


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


func initialize_video_settings() -> void:
	GlobalUserSettings.video[ "fullscreen" ] = initial_fullscreen
	GlobalUserSettings.video[ "window_scale" ] = initial_window_scale
	GlobalUserSettings.video[ "game_scale" ] = initial_window_scale
	set_window_scale( initial_window_scale )
	toggle_fullscreen( initial_fullscreen )
	set_game_scale( initial_game_scale )


func _ready() -> void:
	populate_languages()
	GlobalUserSettings.get_display_info()
	initialize_video_settings()
	nOptionButtonLanguages.grab_focus()


func destroy() -> void:
	if( is_queued_for_deletion() ):
		return
	#	End defensive return
	queue_free()
