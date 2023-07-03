extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nOptionButtonLanguages: OptionButton = get_node(
		"HBCLanguages/OptionButtonLanguage" )


func set_language( index: int ) -> void:
	index = max( index, 0 )
	var full_name: String = nOptionButtonLanguages.get_item_text( index )
	owner.emit_signal( "new_language", GlobalUserSettings.languages[ full_name ] )


func populate_languages() -> void:
	for full_name in GlobalUserSettings.languages.keys():
		nOptionButtonLanguages.add_item( full_name )
	nOptionButtonLanguages.select( 0 )


func update_from_load() -> void:
	var current_language: String = GlobalUserSettings.get_current_language()
	if( current_language == "" ):
		return
	var languages: Array = GlobalUserSettings.get_language_codes()
	var language_index: int = languages.find( current_language )
	nOptionButtonLanguages.select( language_index )
	set_language( language_index )


func _ready() -> void:
	populate_languages()
