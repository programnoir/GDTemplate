extends Node

signal new_fontlist

#	Fallback logarithmic formula for font scaling.
#	f(x) = offset + ( scale * log( x ^ exponent ) )
const MAX_FONT_OFFSET: int = 26
const MAX_FONT_SCALE: int = 140
const MAX_FONT_EXPONENT: float = 0.8

var theme: Theme
var thread_font: Thread
var thread_font_size: Thread

#	Maximum font sizes according to Game Scale
var maximum_font_sizes: Array = [ 26, 55, 82, 100 ]

#	Needs to consistently match the language codes in the translation sheet.
var font_list: Dictionary = {
	'en': {
		'Atkinson Hyperlegible': [
			'res://assets/fonts/Atkinson-Hyperlegible-Regular-102.ttf', 1.0 ],
		'OpenDyslexic': [ 'res://assets/fonts/OpenDyslexic-Regular.otf', 0.85 ]
	},
	'ja': {
		'Noto Sans JP': [ 'res://assets/fonts/NotoSansJP-Regular.ttf', 0.95 ],
		'モリサワのBIZ UDゴシックは': [
			'res://assets/fonts/BIZUDGothic-Regular.ttf', 0.9 ]
	}
}


func set_theme( new_theme: Theme ) -> void:
	theme = new_theme


func get_maximum_font_sizes( index: int ) -> int:
	if( index < maximum_font_sizes.size() ):
		return maximum_font_sizes[ index ]
	return MAX_FONT_OFFSET + round( MAX_FONT_SCALE * \
			log( pow( index, MAX_FONT_EXPONENT ) ) )


func get_font( font_name: String ) -> Font:
	var fonts: Dictionary = font_list[
			GlobalUserSettings.get_current_language() ]
	if( fonts.has( font_name ) == false ):
		return null
	var font: Array = fonts[ font_name ]
	#	End defensive return: No font found?
	return load( font[ 0 ] )


func set_font_threaded( type: String, preloaded_font: Font ) -> void:
	theme.call_deferred( "set_font", "font", type, preloaded_font )


func set_font( new_font: String ) -> void:
	var preloaded_font: Font = get_font( new_font )
	if( preloaded_font == null ):
		return
	#	End defensive return: No filepath found.
	for type in theme.get_type_list():
		var timer: SceneTreeTimer
		if( thread_font != null ):
			thread_font.wait_to_finish()
		thread_font = Thread.new()
		timer = get_tree().create_timer( 0.01 ) 
		#	Retrieves the filepath to the new font.
		thread_font.start( set_font_threaded.bind( 
				type, preloaded_font ) )
		await timer.timeout


func set_font_size_threaded( type: String, new_size: int ) -> void:
	theme.call_deferred( "set_font_size", "font_size", type, new_size )


func get_adjusted_font_size( font_name: String ) -> int:
	var fonts: Dictionary = font_list[
			GlobalUserSettings.get_current_language() ]
	var font: Array = fonts[ font_name ]
	var adjusted_font_size: float = font[ 1 ] * (
			GlobalUserSettings.get_current_font_size() as float )
	return adjusted_font_size as int


func set_font_size( new_size: int ) -> void:
	for type in theme.get_type_list():
		var timer: SceneTreeTimer
		if( thread_font_size != null ):
			thread_font_size.wait_to_finish()
		thread_font_size = Thread.new()
		timer = get_tree().create_timer( 0.01 ) 
		thread_font_size.start( set_font_size_threaded.bind(
				type, new_size ) )
		await timer.timeout


func _exit_tree() -> void:
	if( thread_font != null ):
		thread_font.wait_to_finish()
	if( thread_font_size != null ):
		thread_font_size.wait_to_finish()
