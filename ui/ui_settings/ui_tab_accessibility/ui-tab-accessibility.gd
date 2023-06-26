extends VBoxContainer

@onready var cSig = get_node( "cSig" )
@onready var nUIOptionButtonLanguages = get_node(
		"HBCLanguages/UIOptionButtonLanguage" )

func set_language( index: int ) -> void:
	index = max( index, 0 )
	var full_name: String = nUIOptionButtonLanguages.get_item_text( index )
	owner.emit_signal( "new_language", UserSettings.languages[ full_name ] )


func populate_languages() -> void:
	for full_name in UserSettings.languages.keys():
		nUIOptionButtonLanguages.add_item( full_name )
	nUIOptionButtonLanguages.select( 0 )


func update_from_load() -> void:
	var current_language: String = UserSettings.get_current_language()
	if( current_language == "" ):
		return
	var languages: Array = UserSettings.get_language_codes()
	var language_index: int = languages.find( current_language )
	nUIOptionButtonLanguages.select( language_index )
	set_language( language_index )


func _ready() -> void:
	populate_languages()
