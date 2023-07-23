extends Node

#	Needs to consistently match the language list in global user settings.
var font_list: Dictionary = {
	'en': {
		'Atkinson Hyperlegible': \
				'res://assets/fonts/Atkinson-Hyperlegible-Regular-102.ttf',
		'OpenDyslexic': \
				'res://assets/fonts/OpenDyslexic-Regular.otf'
	},
	'JP': {
		'Noto Sans JP': \
				'res://assets/fonts/NotoSansJP-Regular.ttf',
		'モリサワのBIZ UDゴシックは': \
				'res://assets/fonts/BIZUDGothic-Regular.ttf'
	}
}


func get_font_filepath( font_name: String ) -> String:
	var fonts: Dictionary = font_list[
			GlobalUserSettings.get_current_language() ]
	if( fonts.has( font_name ) == false ):
		return "null"
	#	End defensive return: No font found?
	return fonts[ font_name ]
