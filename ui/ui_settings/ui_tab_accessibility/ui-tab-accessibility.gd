extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nOptionButtonLanguages: OptionButton = get_node(
		"HBCLanguages/OptionButtonLanguage" )
@onready var nHBCFonts: HBoxContainer = get_node( "HBCFonts" )
@onready var nButtonPrevFont: Button = nHBCFonts.get_node( "ButtonPrevFont" )
@onready var nLabelCurrentFont: Label = nHBCFonts.get_node( "LabelCurrentFont" )
@onready var nButtonNextFont: Button = nHBCFonts.get_node( "ButtonNextFont" )

var font_array: Array = []


func set_font( font_index: int ) -> void:
	#	Wrap index around array limits
	if( font_index < 0 ):
		font_index = font_array.size() - 1
	elif( font_index >= font_array.size() ):
		font_index = 0
	GlobalUserSettings.set_current_font_index( font_index )
	nLabelCurrentFont.text = font_array[ font_index ]
	GlobalUserSettings.save_settings()
	owner.emit_signal( "new_font", font_array[ font_index ] )


func populate_font_list() -> void:
	print( GlobalUserSettings.get_current_language() )
	font_array = GlobalFontList.font_list[
			GlobalUserSettings.get_current_language() ].keys()


func set_language( index: int ) -> void:
	print( "Setting language" )
	var full_name: String = nOptionButtonLanguages.get_item_text(
			max( index, 0 ) )
	owner.emit_signal( "new_language",
			GlobalUserSettings.languages[ full_name ] )


func populate_languages() -> void:
	for full_name in GlobalUserSettings.languages.keys():
		nOptionButtonLanguages.add_item( full_name )
	nOptionButtonLanguages.select( 0 )


func update_from_load() -> void:
	var current_language: String = GlobalUserSettings.get_current_language()
	if( current_language == "" ):
		return
	#	End defensive return: Currentl language not set/is default.
	var languages: Array = GlobalUserSettings.get_language_codes()
	var language_index: int = languages.find( current_language )
	nOptionButtonLanguages.select( language_index )
	set_language( language_index )


func _ready() -> void:
	populate_languages()
