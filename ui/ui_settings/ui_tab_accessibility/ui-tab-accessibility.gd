extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nOptionButtonLanguages: OptionButton = get_node(
		"HBCLanguages/OptionButtonLanguage" )
@onready var nButtonCycleFont: ButtonCycle = get_node(
		"HBCFonts/ButtonCycleFont" )
@onready var nSpinBoxFontSize: SpinBox = get_node(
		"HBCFontSizes/SpinBoxFontSize" )
@onready var nSpinBoxLineEditFontSize: LineEdit = \
		nSpinBoxFontSize.get_line_edit()
@onready var nButtonToggleFontSize: Button = get_node(
		"HBCFontSizes/ButtonToggleFontSize" )

const MINIMUM_FONT_SIZE: int = 8
const DEFAULT_FONT_INDEX: int = 0


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
	populate_font_list()
	set_font( DEFAULT_FONT_INDEX )
	nButtonCycleFont.set_index_manual( DEFAULT_FONT_INDEX )
	owner.emit_signal( "new_language",
			GlobalUserSettings.languages[ full_name ] )


func populate_languages() -> void:
	for full_name in GlobalUserSettings.languages.keys():
		nOptionButtonLanguages.add_item( full_name )
	nOptionButtonLanguages.select( 0 )


func update_from_load() -> void:
	var current_language: String = GlobalUserSettings.get_current_language()
	#	Game wouldn't set the right font after loading from settings.
	var current_font_index: int = GlobalUserSettings.get_current_font_index()
	if( current_language == "" ):
		return
	#	End defensive return: Current language not set/is default.
	var languages: Array = GlobalUserSettings.get_language_codes()
	var language_index: int = languages.find( current_language )
	nOptionButtonLanguages.select( language_index )
	set_language( language_index )
	#	I am having trouble finding a non-gross way of doing this.
	set_font( current_font_index )
	nButtonCycleFont.set_index_manual( current_font_index )
	set_font_size( GlobalUserSettings.get_current_font_size() )


func _ready() -> void:
	populate_languages()
