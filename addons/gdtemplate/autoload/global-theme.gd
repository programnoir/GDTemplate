extends Node

signal new_fontlist

var theme: Theme
var thread_font_array: Array
var thread_font_size_array: Array

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


func set_thread_arrays() -> void:
	for type in theme.get_type_list():
		thread_font_array.append( null )
		thread_font_size_array.append( null )


func set_theme( new_theme: Theme ) -> void:
	theme = new_theme


func get_font( font_name: String ) -> Font:
	var fonts: Dictionary = font_list[
			GlobalUserSettings.get_current_language() ]
	if( fonts.has( font_name ) == false ):
		return null
	#	End defensive return: No font found?
	return fonts[ font_name ]


func set_font_threaded( type: String, preloaded_font: Font ) -> void:
	theme.call_deferred( "set_font", "font", type, preloaded_font )


func set_font( new_font: String ) -> void:
	var preloaded_font: Font = get_font( new_font )
	if( preloaded_font == null ):
		return
	#	End defensive return: No filepath found.
	var i: int = 0
	for type in theme.get_type_list():
		var timer: SceneTreeTimer
		if( thread_font_array[ i ] != null ):
			thread_font_array[ i ].wait_to_finish()
		thread_font_array[ i ] = Thread.new()
		timer = get_tree().create_timer( 0.01 ) 
		#	Retrieves the filepath to the new font.
		thread_font_array[ i ].start( set_font_threaded.bind( 
				type, preloaded_font ) )
		i += 1
		await timer.timeout


func set_font_size_threaded( type: String, new_size: int ) -> void:
	theme.call_deferred( "set_font_size", "font_size", type, new_size )


func set_font_size( new_size: int ) -> void:
	var i: int = 0
	for type in theme.get_type_list():
		var timer: SceneTreeTimer
		if( thread_font_size_array[ i ] != null ):
			thread_font_size_array[ i ].wait_to_finish()
		thread_font_size_array[ i ] = Thread.new()
		timer = get_tree().create_timer( 0.01 ) 
		thread_font_size_array[ i ].start( set_font_size_threaded.bind(
				type, new_size ) )
		i += 1
		await timer.timeout


func _exit_tree():
	for thread_font in thread_font_array:
		if( thread_font != null ):
			thread_font.wait_to_finish()
	for thread_font_size in thread_font_size_array:
		if( thread_font_size != null ):
			thread_font_size.wait_to_finish()
