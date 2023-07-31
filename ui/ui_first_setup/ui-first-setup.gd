extends Control

signal new_language
signal completed_first_setup

@onready var nSignals: Node = get_node( "Signals" )
@onready var nVBCFirstSetup: VBoxContainer = get_node(
		"Panel/SCFirstSetup/VBCFirstSetup" )
@onready var nOptionButtonLanguages: OptionButton = nVBCFirstSetup.get_node(
		"HBCLanguages/OptionButtonLanguage" )
@onready var nButtonCycleFont: ButtonCycle = nVBCFirstSetup.get_node(
		"HBCFont/ButtonCycleFont" )
@onready var nCheckButtonFullScreen: CheckButton = nVBCFirstSetup.get_node(
		"CheckButtonFullscreen")
@onready var nLabelWindowScale: Label = nVBCFirstSetup.get_node(
		"HBCWindowScale/LabelWindowScale" )
@onready var nLabelGameScale: Label = nVBCFirstSetup.get_node(
		"HBCGameScale/LabelGameScale" )
@onready var nSpinBoxFontSize: SpinBox = nVBCFirstSetup.get_node(
		"HBCFontSize/SpinBoxFontSize" )
@onready var nSpinBoxLineEditFontSize: LineEdit = \
		nSpinBoxFontSize.get_line_edit()
@onready var nButtonToggleFontSize: Button = nVBCFirstSetup.get_node(
		"HBCFontSize/ButtonToggleFontSize" )

@export var initial_fullscreen: bool = false
@export var initial_window_scale: int = 1
@export var initial_game_scale: int = 1

const MINIMUM_FONT_SIZE: int = 8


func set_font_size( new_size: int ) -> void:
	var adjusted_size: int = new_size
	var maximum_font_size: int = GlobalTheme.maximum_font_sizes[
			GlobalUserSettings.get_game_scale() - 1 ]
	new_size = clamp( new_size, MINIMUM_FONT_SIZE, maximum_font_size )
	GlobalUserSettings.set_current_font_size( new_size )
	GlobalUserSettings.save_settings()
	adjusted_size = GlobalTheme.get_adjusted_font_size(
			nButtonCycleFont.text )
	GlobalTheme.set_font_size( adjusted_size )
	nSpinBoxFontSize.set_value_no_signal( new_size )
	nSpinBoxLineEditFontSize.text = str( new_size )


func toggle_font_size( button_pressed: bool ) -> void:
	if( nSpinBoxFontSize.editable == false ):
		nButtonToggleFontSize.focus_previous = \
				nButtonToggleFontSize.get_path_to( nSpinBoxLineEditFontSize )
		nButtonToggleFontSize.focus_neighbor_left = \
				nButtonToggleFontSize.get_path_to( nSpinBoxLineEditFontSize )
		nSpinBoxLineEditFontSize.grab_focus()
		nButtonToggleFontSize.text = tr( "ui_button_confirm" )
	else:
		nButtonToggleFontSize.focus_previous = nSpinBoxFontSize.get_path_to(
				nButtonCycleFont )
		nButtonToggleFontSize.focus_neighbor_left = \
				nButtonToggleFontSize.get_path_to( nButtonToggleFontSize )
		nButtonToggleFontSize.text = tr( "ui_button_edit" )
		set_font_size( nSpinBoxFontSize.value as int )
	nSpinBoxFontSize.editable = button_pressed


func set_font( font_index: int ) -> void:
	var font_array: Array = nButtonCycleFont.get_list()
	GlobalUserSettings.set_current_font_index( font_index )
	nButtonCycleFont.text = font_array[ font_index ]
	GlobalUserSettings.save_settings()
	GlobalTheme.set_font( font_array[ 
			GlobalUserSettings.get_current_font_index() ] )
	#	Adjusts the font size visually only.
	var adjusted_size: int = GlobalTheme.get_adjusted_font_size(
			nButtonCycleFont.text )
	GlobalTheme.set_font_size( adjusted_size )


func populate_font_list() -> void:
	nButtonCycleFont.set_list( GlobalTheme.font_list[
			GlobalUserSettings.get_current_language() ].keys() )


func set_language( index: int ) -> void:
	var full_name: String = nOptionButtonLanguages.get_item_text(
			max( index, 0 ) )
	GlobalUserSettings.set_new_language( 
			GlobalUserSettings.languages[ full_name ] )
	GlobalUserSettings.save_settings()
	GlobalActionConfig.set_new_replaces( index + 1 )
	populate_font_list()
	set_font( 0 )
	emit_signal( "new_language", GlobalUserSettings.languages[ full_name ] )


func populate_languages() -> void:
	for full_name in GlobalUserSettings.languages.keys():
		nOptionButtonLanguages.add_item( full_name )
	nOptionButtonLanguages.select( 0 )


func set_game_scale( new_scale: int ) -> void:
	GlobalUserSettings.set_game_scale( new_scale )
	nLabelGameScale.text = String.num( GlobalUserSettings.get_game_scale() )
	#	Game scale impacts font size.
	set_font_size( GlobalUserSettings.get_current_font_size() )


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
	nSignals.connect_signals()
	populate_languages()
	populate_font_list()
	GlobalUserSettings.get_display_info()
	initialize_video_settings()
	nOptionButtonLanguages.grab_focus()


func destroy() -> void:
	if( is_queued_for_deletion() ):
		return
	#	End defensive return
	nSignals.disconnect_signals()
	queue_free()
