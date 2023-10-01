@tool
extends DialogNodeOptions
class_name DialogNodeOptionsAdvanced


@onready var nSignals: Node = get_node( "Signals" )
#	Speaker/Keyframe
@onready var nTabDialog: VBoxContainer = get_node( "TabContainer/Dialog" )
@onready var nTabResponses: VBoxContainer = get_node( "TabContainer/Responses" )
@onready var nOptionButtonSpeaker: OptionButton = nTabDialog.get_node(
		"HBCSpeaker/OptionButtonSpeaker" )
@onready var nLabelCurrentKeyframe: Label = nTabDialog.get_node(
		"HBCSpeaker/LabelCurrentKeyframe" )
#	Keyframe navigation and editing
@onready var nButtonPreviousKeyframe: Button = nTabDialog.get_node(
		"HBCKeyframeNav/ButtonPreviousKeyframe")
@onready var nButtonNextKeyframe: Button = nTabDialog.get_node(
		"HBCKeyframeNav/ButtonNextKeyframe")
@onready var nRichTextLabel: RichTextLabel = nTabDialog.get_node(
		"HBCKeyframeNav/RichTextLabel" )
@onready var nButtonAppendKeyframe: Button = nTabDialog.get_node(
		"HBCKeyframeNav/VBCAddDelete/ButtonAppendKeyframe" )
@onready var nButtonDeleteKeyframe: Button = nTabDialog.get_node(
		"HBCKeyframeNav/VBCAddDelete/ButtonDeleteKeyframe" )
@onready var nTextEdit: TextEdit = nTabDialog.get_node( "TextEdit" )
#	Keyframe options
@onready var nTabTypeColor: VBoxContainer = nTabDialog.get_node(
		"TabContainer/Type & Color" )
@onready var nTabTiming: VBoxContainer = nTabDialog.get_node(
		"TabContainer/Timing" )
@onready var nTabAnimations: VBoxContainer = nTabDialog.get_node(
		"TabContainer/Animations" )
@onready var nTabAudio: VBoxContainer = nTabDialog.get_node(
		"TabContainer/Audio" )
@onready var nTabData: VBoxContainer = nTabDialog.get_node(
		"TabContainer/Data" )
#	Responses
@onready var nCheckBoxResponses: CheckBox = nTabResponses.get_node(
		"HBCResponseOptions/CheckBoxResponses" )
@onready var nVBCResponses: VBoxContainer = nTabResponses.get_node(
		"SCResponses/VBCResponses" )

const SELECT_COLOR: Color = Color( 1.0, 1.0, 0 )

var flags_array: Array = []
var floats_array: Array = []
var strings_array: Array = []
var arrays_array: Array = []
var speakers_array: Array = []
var colors_array: Dictionary = {}

var current_keyframe: int = 0


func get_keyframe_property( property: String ) -> Variant:
	return node_data[ "keyframes" ][ current_keyframe ][ property ]


#	Complete
func select_by_text( option_button: OptionButton, text: String ) -> void:
	for item_id in range( 0, option_button.item_count ):
		var item_text: String = option_button.get_item_text( item_id )
		if( text == item_text ):
			option_button.select( item_id )
			return


func pass_variable_data(
		flags: Array,
		floats: Array,
		strings: Array,
		arrays: Array,
		speakers: Array,
		colors: Dictionary
) -> void:
	flags_array = flags.duplicate()
	floats_array = floats.duplicate()
	strings_array = strings.duplicate()
	arrays_array = arrays.duplicate()
	speakers_array = speakers.duplicate()
	colors_array = colors
	#	Speakers


func update_rich_text() -> void:
	nRichTextLabel.clear()
	var key_index: int = 0
	for key in node_data[ "keyframes" ]:
		if( key_index == current_keyframe ):
			nRichTextLabel.push_color( SELECT_COLOR )
			nRichTextLabel.append_text( key[ "text" ] )
			nRichTextLabel.pop()
		else:
			nRichTextLabel.append_text( key[ "text" ] )
		key_index += 1


func load_keyframe() -> void:
	update_rich_text()
	nTextEdit.text = node_data[ "keyframes" ][ current_keyframe ][ "text" ]
	nLabelCurrentKeyframe.text = str( current_keyframe )
	nTabTypeColor.load_current_keyframe()
	nTabAudio.load_current_keyframe()
	nTabTiming.load_current_keyframe()
	nTabAnimations.load_current_keyframe()
	nTabData.load_current_keyframe()


func save_current_keyframe() -> void:
	#	This saves all the info that is affected by the tabs.
	var data: Dictionary = {}
	data[ "text" ] = nTextEdit.text
	#	Populate data with data from tabs
	nTabTypeColor.save_current_keyframe( data )
	nTabAudio.save_current_keyframe( data )
	nTabTiming.save_current_keyframe( data )
	nTabAnimations.save_current_keyframe( data )
	nTabData.save_current_keyframe( data )
	#	Add data to keyframes
	node_data[ "keyframes" ][ current_keyframe ] = data.duplicate( true )


func update_current_keyframe( delta: int ) -> void:
	save_current_keyframe()
	current_keyframe = clamp( current_keyframe + delta, 0,
			node_data[ "keyframes" ].size() - 1 )
	load_keyframe()


func delete_current_keyframe() -> void:
	if( node_data[ "keyframes" ].size == 1 ):
		return
	#	End defensive return: No keyframes left to delete.
	node_data[ "keyframes" ].remove_at( current_keyframe )
	current_keyframe = clamp( current_keyframe, 0,
			node_data[ "keyframes" ].size() )
	load_keyframe()


func create_advanced_node_keyframe() -> void:
	var new_data: Dictionary = {
		#	Required information
		"text_type": "Default",
		"text": "",
		#	Customization: Type/Color
		"using_text_color": true,
		"text_color": "Custom",
		"text_color_custom": Color( 0.0, 0.0, 0.0, 1.0 ),
		#	Timing/Speed
		"timer_delay": 0.000,
		"write_speed": 1.000,
		"ignore_player_speed_delay": false,
		"ignore_player_speed_write": false,
		#	Images
		"animations": [], #	{ "id":X, "animation":"example" }, {}, {}
		#	Sounds
		"sound_effect": "",
		"sound_typewriter": "",
		"music": "",
		"music_transition": "Cut",
		#	Custom data specifically for *association* with the text.
		"custom_data": [],
		#	Variable data set prior to the node, for injection/association.
		"variable_data": []
	}
	if( node_data[ "keyframes" ].size() == 0 ):
		node_data[ "keyframes" ].insert( 0, new_data )
	else:
		node_data[ "keyframes" ].insert( current_keyframe + 1, new_data )
		update_current_keyframe( 1 )


func add_responses( delta: int ) -> void:
	match delta:
		-1:
			var children: Array = nVBCResponses.get_children()
			if( children.size() == 0 ):
				return
			#	End defensive return: No remaining children.
			nVBCResponses.get_child( children.size() - 1 ).queue_free()
		1:
			var new_response: LineEdit = LineEdit.new()
			nVBCResponses.add_child( new_response )


func write_node_data() -> void:
	if( nOptionButtonSpeaker.item_count > 0 ):
		node_data[ "speaker" ] = nOptionButtonSpeaker.get_item_text( 
				nOptionButtonSpeaker.selected )
	save_current_keyframe()
	if( nCheckBoxResponses.button_pressed == true ):
		var response_array: Array = []
		for child in nVBCResponses.get_children():
			response_array.append( child.text )
		node_data[ "responses" ] = response_array.duplicate()
	else:
		if( node_data.has( "responses" ) ):
			node_data.erase( "responses" )
	#	Cleanup
	nTabAnimations.clear_animations()


func populate_ui() -> void:
	if( node_data.size() == 0 ):
		return
	#	End defensive return: No data yet.
	for speaker in speakers_array:
		nOptionButtonSpeaker.add_item( speaker )
	if( node_data.has( "speaker" ) ):
		if( node_data[ "speaker" ] != "" ):
			select_by_text( nOptionButtonSpeaker, node_data[ "speaker" ] )
	nTabTypeColor.populate_ui()
	nTabData.populate_ui()
	if( node_data[ "keyframes" ].size() == 0 ):
		create_advanced_node_keyframe()
	load_keyframe()
	if( node_data.has( "responses" ) ):
		nCheckBoxResponses.button_pressed = true
		for response in node_data[ "responses" ]:
			var new_response: LineEdit = LineEdit.new()
			new_response.text = response
			nVBCResponses.add_child( new_response )
