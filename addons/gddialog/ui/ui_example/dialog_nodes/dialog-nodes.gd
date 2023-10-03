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


func process_simple_text() -> void:
	if( owner.nRichTextLabelDialog.visible_characters == 
			owner.nRichTextLabelDialog.get_total_character_count()
	):
		owner.nASPTypewriter.stop()
		owner.nTimerTypewriter.stop()
		owner.is_playing = false
		return
	#	End defensive return.
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


func line_dialog() -> void:
	#	Now to get the record text.
	owner.nRichTextLabelDialog.clear()
	owner.nRichTextLabelSpeaker.clear()
	owner.nRichTextLabelDialog.set_visible_characters( 0 )
	var line: String = owner.reader.get_text( owner.record_id,
			owner.node_id )
	var speaker: String = owner.reader.get_speaker( owner.record_id,
			owner.node_id )
	var speaker_color: Color = owner.reader.get_speaker_color( speaker )
	var color_hex: String = speaker_color.to_html( true )
	var bbcode_string: String = "[color=#" + color_hex + "]"\
					+ speaker + "[/color]"
	owner.is_playing = true
	owner.nRichTextLabelSpeaker.append_text( bbcode_string )
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
	gui_type = owner.reader.get_gui_type(
			owner.record_id, owner.node_id )
	#	Handle your set gui code here.
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
