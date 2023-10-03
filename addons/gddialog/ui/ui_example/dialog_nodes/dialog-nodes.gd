extends Node

var gui_type: String = ""

var dialog_types: Dictionary = {
	"End": Callable( self, "end_dialog" ),
	"Line": Callable( self, "line_dialog" ),
	"Advanced": Callable( self, "advanced_dialog" ),
	"If": Callable( self, "if_dialog" ),
	"Set": Callable( self, "set_dialog" ),
	"Set GUI": Callable( self, "set_gui_dialog" ),
	"Run Script": Callable( self, "run_script" )
}


func set_typewriter_delays() -> void:
	owner.nRichTextLabelDialog.set_visible_characters(
			owner.nRichTextLabelDialog.get_visible_characters() + 1 )
	if( owner.nRichTextLabelDialog.text.substr(
			0, owner.nRichTextLabelDialog.get_visible_characters()
		).ends_with( " " ) == false
	):
		owner.nASPTypewriter.play( 0.0 )
		owner.nTimerTypewriter.start( owner.write_speed )
	else:
		owner.nTimerTypewriter.start( owner.write_speed / 2 )


func process_current_keyframe() -> void:
	#	Process the keyframe's text.
	if( owner.nRichTextLabelDialog.visible_characters == 
			owner.nRichTextLabelDialog.get_total_character_count()
	):
		setup_current_keyframe()
		return
	#	End defensive return: Completed keyframe.
	#	Setup Sound effect and music
	var current_keyframe: Dictionary = owner.current_keyframe
	if( current_keyframe[ "sound_effect" ] != "" ):
		owner.nASPSoundEffect.stop()
		if( current_keyframe[ "sound_effect" ].to_lower() != "stop" ):
			owner.nASPSoundEffect.set_stream( 
					load( current_keyframe[ "sound_effect" ] ) )
	if( current_keyframe[ "music" ] != "" ):
		var new_song: String = current_keyframe[ "music" ]
		match current_keyframe[ "music_transition" ]:
			"Cut":
				owner.nASPSoundEffect.stop()
				if( current_keyframe[ "music" ].to_lower() != "stop" ):
					owner.nASPMusic.set_stream( 
							load( current_keyframe[ "sound_effect" ] ) )
	#	Process changes to portraits
	for anim in current_keyframe[ "animations" ]:
		owner.portraits_array[ anim[ "id" ] ].play( anim[ "animation" ] )
	set_typewriter_delays()


func setup_current_keyframe() -> void:
	if( owner.keyframes_array.size() == 0 ):
		owner.nASPTypewriter.stop()
		owner.nTimerTypewriter.stop()
		owner.nTimerDelay.stop()
		owner.is_playing = false
		return
	#	End defensive return.
	#	Gather data
	owner.current_keyframe = owner.keyframes_array.pop_front()
	var current_keyframe: Dictionary = owner.current_keyframe
	#	Handle write speed
	var player_write_speed: float = 1.0
	if( current_keyframe[ "ignore_player_speed_write" ] == false ):
		player_write_speed = GlobalUserSettings.accessibility[ "text_speed" ]
	owner.write_speed = max( owner.FASTEST_WRITE_SPEED,
			owner.DEFAULT_WRITE_SPEED * current_keyframe[ "write_speed" ] * \
			player_write_speed )
	#	Handle color choice
	var color: Color = owner.DEFAULT_COLOR
	if( current_keyframe[ "using_text_color" ] == true ):
		if( current_keyframe[ "text_color" ] == "Custom" ):
			color = current_keyframe[ "text_color_custom" ]
		else:
			color = owner.reader.get_color( current_keyframe[ "text_color" ] )
	#	First, process text type.
	match current_keyframe[ "text_type" ]:
		"Default":
			var color_hex: String = color.to_html()
			var bbcode_string: String = "[color=#" + color_hex + "]"\
					+ current_keyframe[ "text" ] + "[/color]"
			owner.nRichTextLabelDialog.append_text( bbcode_string )
	#	Handle typewriter noise
	if( current_keyframe[ "sound_typewriter" ] != "" ):
		owner.is_using_default_typewriter = false
		owner.nASPTypewriter.set_stream( load( 
				current_keyframe[ "sound_typewriter" ] ) )
	elif( owner.is_using_default_typewriter == false ):
		owner.is_using_default_typewriter = true
		owner.nASPTypewriter.set_stream( 
				load( owner.DEFAULT_TYPEWRITER ) )
	#	Handle delay
	var delay: float = current_keyframe[ "timer_delay" ]
	if( current_keyframe[ "ignore_player_speed_delay" ] == true ):
		delay /= GlobalUserSettings.accessibility[ "text_delay" ]
	delay = max( owner.FASTEST_WRITE_SPEED, delay )
	owner.nTimerDelay.start( delay )


func set_speaker() -> void:
	owner.nRichTextLabelSpeaker.clear()
	var speaker: String = owner.reader.get_speaker( owner.record_id,
			owner.node_id )
	var speaker_color: Color = owner.reader.get_speaker_color( speaker )
	var color_hex: String = speaker_color.to_html( true )
	var bbcode_string: String = "[color=#" + color_hex + "]"\
					+ speaker + "[/color]"
	owner.nRichTextLabelSpeaker.append_text( bbcode_string )


func advanced_dialog() -> void:
	var responses: Array = owner.reader.get_responses(
			owner.record_id, owner.node_id )
	if( responses.size() > 0 ):
		set_gui_dialog( "question", false )
	else:
		set_gui_dialog( "default", false )
	owner.nRichTextLabelDialog.clear()
	owner.nRichTextLabelDialog.set_visible_characters( 0 )
	set_speaker()
	owner.is_playing = true
	owner.keyframes_array = owner.reader.get_keyframes(
			owner.record_id, owner.node_id ).duplicate( true )
	setup_current_keyframe()


func process_simple_text() -> void:
	if( owner.nRichTextLabelDialog.visible_characters == 
			owner.nRichTextLabelDialog.get_total_character_count()
	):
		owner.nASPTypewriter.stop()
		owner.nTimerTypewriter.stop()
		owner.is_playing = false
		return
	#	End defensive return.
	set_typewriter_delays()


func line_dialog() -> void:
	#	Now to get the record text.
	owner.nRichTextLabelDialog.clear()
	owner.nRichTextLabelDialog.set_visible_characters( 0 )
	var line: String = owner.reader.get_text( owner.record_id,
			owner.node_id )
	owner.is_playing = true
	set_speaker()
	owner.nRichTextLabelDialog.append_text( line )
	owner.write_speed = 0.05 / GlobalUserSettings.accessibility[ "text_speed" ]
	owner.nTimerTypewriter.start( owner.write_speed )


func if_dialog() -> void:
	owner.slot = owner.reader.get_if_node_slot_common(
			owner.record_id, owner.node_id )
	owner.process_next_node()


func set_dialog() -> void:
	owner.reader.set_variable_common( owner.record_id, owner.node_id )
	owner.slot = 0
	owner.process_next_node()


func set_gui_dialog( type: String = "", next_node: bool = true ) -> void:
	if( type == "" ):
		gui_type = owner.reader.get_gui_type(
				owner.record_id, owner.node_id )
	#	Handle your set gui code here.
	if( type == "question" ):
		#	Responses to questions are entered in the Advanced dialog node.
		#	You don't need a Set GUI node to set up questions/answers.
		var responses: Array = owner.reader.get_responses(
			owner.record_id, owner.node_id )
		if( responses.size() > 0 ):
			owner.nPanelResponses.setup_responses( responses )
	elif( type == "default" ):
		owner.nPanelResponses.visible = false
	if( next_node == false ):
		return
	#	End defensive return
	owner.slot = 0
	owner.process_next_node()


func run_script() -> void:
	#	Get path to .gd file and the name of the funcref entry in Dictionary.
	var script_path: String = owner.reader.get_script_path(
			owner.record_id, owner.node_id )
	var script_name: String = owner.reader.get_script_name(
			owner.record_id, owner.node_id )
	#	Execute the code.
	var script: Node = load( script_path ).instantiate()
	add_child( script )
	var go_to_next_node: bool = script.funcrefs[ script_name ].call()
	if( script.has_method( "destroy" ) ):
		script.destroy()
	else:
		script.queue_free()
	#	Process the next node.
	if( go_to_next_node == true ):
		owner.slot = 0
		owner.process_next_node()


func end_dialog() -> void:
	owner.nRichTextLabelDialog.clear()
	owner.nRichTextLabelSpeaker.clear()
	owner.visible = false
	owner.emit_signal( "toggle_visible", false )
	owner.trigger_button.grab_focus()


func process_node() -> void:
	owner.node_type = owner.reader.get_node_type(
			owner.record_id, owner.node_id )
	dialog_types[ owner.node_type ].call()
