@tool
extends RichTextLabel

@onready var nASPTypewriter: AudioStreamPlayer = get_node( "ASPTypewriter" )
@onready var nASPSoundEffect: AudioStreamPlayer = get_node( "ASPSoundEffect" )
@onready var nTimerTypewriter: Timer = $TimerWrite
@onready var nTimerDelay: Timer = $TimerDelay

const DEFAULT_TYPEWRITER: String = "res://addons/gddialog/"\
		+ "assets/sounds/blip.ogg"
const DEFAULT_COLOR: Color = Color( 255, 255, 255, 1.0 )
const DEFAULT_WRITE_SPEED: float = 0.05
const FASTEST_WRITE_SPEED: float = 1.0 / 60.0


#	Prevents mashing preview button, for now.
var is_playing: bool = false
#	Current keyframe of this dialog.
var current_preview_keyframe: int = 0
var is_using_default_typewriter: bool = true
#	Default write speed.
var write_speed: float = DEFAULT_WRITE_SPEED
var keyframes_array: Array = []
var current_keyframe: Dictionary = {}


func _on_timer_delay_timeout() -> void:
	process_current_keyframe()


func _on_timer_write_timeout() -> void:
	process_current_keyframe()


func set_typewriter_delays() -> void:
	nTimerDelay.stop()
	nTimerTypewriter.stop()
	set_visible_characters( get_visible_characters() + 1 )
	if( text.substr( 0, get_visible_characters() ).ends_with( " " ) == false ):
		nASPTypewriter.play( 0.0 )
		print( write_speed )
		nTimerTypewriter.start( write_speed )
	else:
		nTimerTypewriter.start( write_speed / 2 )


func process_current_keyframe() -> void:
	#	Process the keyframe's text.
	if( visible_characters == get_total_character_count() ):
		setup_preview_keyframe()
		return
	#	End defensive return: Completed keyframe.
	#	Setup Sound effect and music
	if( current_keyframe[ "sound_effect" ] != "" ):
		nASPSoundEffect.stop()
		if( current_keyframe[ "sound_effect" ].to_lower() != "stop" ):
			nASPSoundEffect.set_stream( 
					load( current_keyframe[ "sound_effect" ] ) )
	set_typewriter_delays()


func setup_preview_keyframe() -> void:
	nTimerDelay.stop()
	nTimerTypewriter.stop()
	if( keyframes_array.size() == 0 ):
		nASPTypewriter.stop()
		nTimerTypewriter.stop()
		is_playing = false
		return
	#	End defensive return - Finished.
	current_keyframe = keyframes_array.pop_front()
	write_speed = max( FASTEST_WRITE_SPEED,
			DEFAULT_WRITE_SPEED * current_keyframe[ "write_speed" ] )
	print( write_speed )
	var color: Color = DEFAULT_COLOR
	if( current_keyframe[ "using_text_color" ] == true ):
		if( current_keyframe[ "text_color" ] == "Custom" ):
			color = current_keyframe[ "text_color_custom" ]
		else:
			#	Not sure that this line works...
			color = owner.colors_array[ current_keyframe[ "text_color" ] ]
	var color_hex: String = color.to_html()
	var bbcode_string: String = "[color=#" + color_hex + "]"\
			+ current_keyframe[ "text" ] + "[/color]"
	#	Add text to Preview.
	append_text( bbcode_string )
	if( current_keyframe[ "sound_typewriter" ] != "" ):
		is_using_default_typewriter = false
		nASPTypewriter.set_stream( load( 
				current_keyframe[ "sound_typewriter" ] ) )
	elif( is_using_default_typewriter == false ):
		is_using_default_typewriter = true
		nASPTypewriter.set_stream( load( DEFAULT_TYPEWRITER ) )
	#	Handle delay
	var delay: float = current_keyframe[ "timer_delay" ]
	#if( current_keyframe[ "ignore_player_speed_delay" ] == true ):
	#	delay /= GlobalUserSettings.accessibility[ "text_delay" ]
	delay = max( FASTEST_WRITE_SPEED, delay )
	nTimerDelay.start( delay )


func preview_dialog() -> void:
	if( is_playing ):
		return
	#	End defensive return: Please wait.
	is_playing = true
	keyframes_array = owner.node_data[ "keyframes" ].duplicate( true )
	set_visible_characters( 0 )
	clear()
	current_preview_keyframe = 0
	current_keyframe.clear()
	setup_preview_keyframe()
