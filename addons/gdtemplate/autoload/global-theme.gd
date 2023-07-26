extends Node

signal new_fontlist

var theme: Theme
var thread_font: Thread
var thread_font_size: Thread

#	Needs to consistently match the language list in global user settings.
var font_list: Dictionary = {
	'en': {
		'Atkinson Hyperlegible': preload(
				'res://assets/fonts/Atkinson-Hyperlegible-Regular-102.ttf' ),
		'OpenDyslexic': preload(
				'res://assets/fonts/OpenDyslexic-Regular.otf' )
	},
	'JP': {
		'Noto Sans JP': preload(
				'res://assets/fonts/NotoSansJP-Regular.ttf' ),
		'モリサワのBIZ UDゴシックは': preload(
				'res://assets/fonts/BIZUDGothic-Regular.ttf' )
	}
}


func set_theme( new_theme: Theme ) -> void:
	theme = new_theme


func get_font( font_name: String ) -> Font:
	var fonts: Dictionary = font_list[
			GlobalUserSettings.get_current_language() ]
	if( fonts.has( font_name ) == false ):
		return null
	#	End defensive return: No font found?
	return fonts[ font_name ]


func set_font_threaded( preloaded_font: Font ) -> void:
	for type in theme.get_type_list():
		theme.set_font( "font", type, preloaded_font )


func set_font( new_font: String ) -> void:
	if( thread_font != null ):
		thread_font.wait_to_finish()
	thread_font = Thread.new()
	#	Retrieves the filepath to the new font.
	var preloaded_font: Font = get_font( new_font )
	if( preloaded_font == null ):
		return
	#	End defensive return: No filepath found.
	thread_font.start( set_font_threaded.bind( preloaded_font ) )


func set_font_size_threaded( new_size: int ) -> void:
	for type in theme.get_type_list():
		theme.set_font_size( "font_size", type, new_size )


func set_font_size( new_size: int ) -> void:
	if( thread_font_size != null ):
		thread_font_size.wait_to_finish()
	thread_font_size = Thread.new()
	thread_font_size.start( set_font_size_threaded.bind( new_size ) )


func _exit_tree():
	thread_font.wait_to_finish()
	thread_font_size.wait_to_finish()
