extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nOptionButtonLanguages: OptionButton = get_node(
		"HBCLanguages/OptionButtonLanguage" )
@onready var nButtonCycleFont: ButtonCycle = get_node(
		"HBCFonts/ButtonCycleFont" )
@onready var nLabelFontSize: Label = get_node(
		"HBCFontSizes/LabelFontSize" )


func set_font_size( new_size: int ) -> void:
	var current_size: int = nLabelFontSize.text as int
	current_size = max( 1, current_size + new_size )
	GlobalUserSettings.set_current_font_size( current_size )
	GlobalUserSettings.save_settings()
	GlobalTheme.set_font_size( current_size )
	nLabelFontSize.text = str( current_size )


func set_font( font_index: int ) -> void:
	var font_array: Array = nButtonCycleFont.get_list()
	GlobalUserSettings.set_current_font_index( font_index )
	nButtonCycleFont.text = font_array[ font_index ]
	GlobalUserSettings.save_settings()
	GlobalTheme.set_font( font_array[ 
			GlobalUserSettings.get_current_font_index() ] )


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
	set_font( 0 )
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
