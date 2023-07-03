extends Node

const CONFIG_DIR: String = "data/saves/"
const CONFIG_FILE_NAME: String = "settings"
const CONFIG_EXTENSION: String = ".tres"

#	Save file information
var accessibility: Dictionary = {
	"current_language": "English"
}
var input_profiles: Dictionary = {
	"profiles": [],
	"profile_names": [],
	"current_profile": "default"
}
var gameplay_options: Dictionary = {}
var video: Dictionary = {}
var audio: Dictionary = {}

"""
	Settings variables
"""

var languages: Dictionary = {
	"English": "en",
	"日本語 (Japanese)": "JP"
}
#	Gets the current screen that the window is on.
var main_window: Window = null
var main_window_id: int = 0
var current_screen: int = DisplayServer.window_get_current_screen(
		DisplayServer.MAIN_WINDOW_ID )
var view: Viewport = get_viewport()
#	Resolution stats
var monitor_size: Vector2i = Vector2i.ZERO
var monitor_aspect_ratio: float = 0.0
#	Specify the smallest possible window size in your project settings.
var base_game_resolution: Vector2i = Vector2i(
		ProjectSettings.get_setting( "display/window/size/viewport_width" ), 
		ProjectSettings.get_setting( "display/window/size/viewport_height" )
) 
var game_resolution: Vector2i = base_game_resolution
var max_scale: float = 1.0


"""
	Saving/Loading Functions
"""


func save_settings() -> void:
	print( "Saving settings" )
	var new_save: = GameSettings.new()
	new_save.accessibility = accessibility.duplicate( true )
	new_save.input_profiles = input_profiles.duplicate( true )
	new_save.gameplay_options = gameplay_options.duplicate( true )
	new_save.video = video.duplicate( true )
	new_save.audio = audio.duplicate( true )
	#
	var dirtext: String = "user://"
	var dir := DirAccess.open( dirtext )
	if( dir.dir_exists( CONFIG_DIR ) == false ):
		dir.make_dir_recursive( CONFIG_DIR )
	ResourceSaver.save( new_save,
			dirtext + CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION )
	var new_load: Resource = ResourceLoader.load(
			dirtext + CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION,
			'Resource', 1 )
	if( new_load != null ):
		print( "Save successful" )
	else:
		print( "Failure?" )


func load_settings() -> bool:
	var dirtext: String = "user://"
	#	File does not exist
	if( ResourceLoader.exists( dirtext + CONFIG_DIR + CONFIG_FILE_NAME + \
			CONFIG_EXTENSION ) == false ):
		print( "Settings save file not found." )
		return false
	var new_load: Resource = ResourceLoader.load(
			dirtext + CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION,
			'Resource', 1 )
	accessibility.clear()
	accessibility = new_load.accessibility.duplicate( true )
	input_profiles = new_load.input_profiles.duplicate( true )
	gameplay_options = new_load.gameplay_options.duplicate( true )
	video = new_load.video.duplicate( true )
	audio = new_load.audio.duplicate( true )
	#	And now we can assign this data to the game.
	return true


"""
	Accessibility & Language
"""

#	Changing the language of the game.
func get_current_language() -> String:
	if( accessibility.has( "current_language" ) == false ):
		return ""
	return accessibility[ "current_language" ]


func get_language_codes() -> Array:
	return languages.values()


func set_new_language( language_code: String ) -> void:
	accessibility[ "current_language" ] = language_code
	TranslationServer.set_locale( language_code )


"""
	Keybind Input Profile
"""


func get_current_input_profile() -> int:
	if( input_profiles[ "profile_names" ].is_empty() ):
		print( "No profiles. Setting to default." )
		return 0
	if( input_profiles[ "current_profile" ] == "default" ):
		print( "Default profile selected" )
		return 0
	return input_profiles[ "profile_names" ].find(
				input_profiles[ "current_profile" ] ) + 1


func get_input_profile_names() -> Array:
	return input_profiles[ "profile_names" ]


func get_input_profile( array_index: int ) -> Dictionary:
	return input_profiles[ "profiles" ][ array_index - 1 ]


func save_changes_to_profile(
		array_index: int,
		input_data: Dictionary
) -> void:
	input_profiles[ "profiles" ][ array_index - 1 ].clear()
	input_profiles[ "profiles" ][ array_index - 1 ] = input_data.duplicate( true )
	save_settings()


func select_input_profile( profile_name: String ) -> bool:
	if( input_profiles[ "profile_names" ].has( profile_name ) == false ):
		print( "Unable to find profile" )
		return false
	input_profiles[ "current_profile" ] = profile_name
	save_settings()
	return true


func add_input_profile( profile_name: String, input_data: Dictionary ) -> void:
	input_profiles[ "profile_names" ].append( profile_name )
	input_profiles[ "profiles" ].append( input_data.duplicate( true ) )
	select_input_profile( profile_name )


func delete_input_profile( array_index: int ) -> void:
	input_profiles[ "profile_names" ].remove_at( array_index )
	input_profiles[ "profiles" ].remove_at( array_index )
	input_profiles[ "current_profile" ] = "default"
	save_settings()


"""
	Audio Controls
"""


func set_bus_volume( bus_id: int, new_value: float ) -> void:
	AudioServer.set_bus_volume_db( bus_id, -80.0 * ( 1.0 - new_value ) )
	audio[ bus_id ] = new_value


"""
	Video Settings
"""

func get_window_scale() -> int:
	return video[ "window_scale" ]


func get_game_scale() -> int:
	return video[ "game_scale" ]


func is_fullscreen() -> bool:
	return video[ "fullscreen" ]


func get_display_info() -> void:
	main_window = get_window()
	current_screen = DisplayServer.window_get_current_screen(
			DisplayServer.MAIN_WINDOW_ID )
	view = get_viewport()
	#	Now for the actual stats.
	#old: ScreenResolution = OS.get_screen_size(OS.current_screen)
	monitor_size = DisplayServer.screen_get_size( current_screen )
	monitor_aspect_ratio = float( monitor_size.x ) / float( monitor_size.y )
	#old: WindowResolution = OS.window_size
	max_scale = ceil(
			float( monitor_size.y ) / float( base_game_resolution.y ) )


func recenter_main_window() -> void:
	get_display_info()
	var main_screen_position: Vector2i = DisplayServer.screen_get_position(
			current_screen )
	var current_screen_center: Vector2i = monitor_size / 2
	var window_center: Vector2i = DisplayServer.window_get_size(
			DisplayServer.MAIN_WINDOW_ID ) / 2
	DisplayServer.window_set_position( main_screen_position + \
			current_screen_center - window_center,
			DisplayServer.MAIN_WINDOW_ID )


func toggle_fullscreen( fullscreen: bool ) -> void:
	if( fullscreen == false ):
		DisplayServer.window_set_mode(
				DisplayServer.WindowMode.WINDOW_MODE_WINDOWED, 0 )
		DisplayServer.window_set_flag( DisplayServer.WINDOW_FLAG_BORDERLESS,
				false )
		DisplayServer.window_set_size( base_game_resolution * 
					video[ "window_scale" ], DisplayServer.MAIN_WINDOW_ID )
		recenter_main_window()
	else:
		DisplayServer.window_set_mode(
				DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN, 0 )
		DisplayServer.window_set_flag( DisplayServer.WINDOW_FLAG_BORDERLESS,
				true )
	video[ "fullscreen" ] = fullscreen


func set_game_scale( new_scale: int ) -> void:
	if( is_fullscreen() == false ):
		video[ "game_scale" ] = clamp( new_scale, 1, video[ "window_scale" ] )
	else:
		video[ "game_scale" ] = clamp( new_scale, 1, max_scale )
	main_window.set_content_scale_size(
			base_game_resolution * video[ "game_scale" ] )


func set_window_scale( new_scale: int ) -> void:
	video[ "window_scale" ] = clamp( new_scale, 1, max_scale )
	if( video[ "window_scale" ] == max_scale ):
		toggle_fullscreen( true )
		return
	toggle_fullscreen( false )
	DisplayServer.window_set_size( base_game_resolution * 
			video[ "window_scale" ], DisplayServer.MAIN_WINDOW_ID )
	set_game_scale( video[ "game_scale" ] )
	recenter_main_window()
