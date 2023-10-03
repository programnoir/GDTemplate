extends Control

signal toggle_visible( visibility: bool )

@onready var nSignals: Node = get_node( "Signals" )
@onready var nDialogNodes: Node = get_node( "DialogNodes" )
@onready var nTimerDelay: Timer = get_node( "Timers/TimerDelay" )
@onready var nTimerTypewriter: Timer = get_node( "Timers/TimerTypewriter" )
@onready var nASPTypewriter: AudioStreamPlayer = get_node(
		"Audio/ASPTypewriter" )
@onready var nColorRect: ColorRect = get_node( "ColorRect" )
@onready var nHBCDialog: HBoxContainer = get_node( "VBCDialog"\
		+ "/MCDialog/PanelDialog/HBCDialog" )
@onready var nRichTextLabelSpeaker: RichTextLabel = nHBCDialog.get_node( 
		"VBCDialogText/RichTextLabelSpeaker" )
@onready var nRichTextLabelDialog: RichTextLabel = nHBCDialog.get_node( 
		"VBCDialogText/RichTextLabelDialog" )
@onready var nPanelResponses: Panel = get_node(
		"VBCDialog/MCDialog/PanelDialog/PanelResponses" )
@onready var nButtonNext: Button = nHBCDialog.get_node(
		"VBCButtons/ButtonNext" )

#	Portraits
@onready var nPortraits: Control = get_node( "VBCDialog/Portraits" )
@onready var nHBCProfiles: Control = nPortraits.get_node( "HBCProfiles" )
@onready var portraits_array: Array = [
	nPortraits.get_node( "ProfilePointBG/UIPortraitBG" ),
	nHBCProfiles.get_node( "ProfileColumnLL/ProfilePoint/UIPortraitLL" ),
	nHBCProfiles.get_node( "ProfileColumnL/ProfilePoint/UIPortraitL" ),
	nHBCProfiles.get_node( "ProfileColumnR/ProfilePoint/UIPortraitR" ),
	nHBCProfiles.get_node( "ProfileColumnRR/ProfilePoint/UIPortraitRR" ),
	nPortraits.get_node( "HBCFG/ProfileColumnL/ProfilePoint/UIPortraitFGL" ),
	nPortraits.get_node( "HBCFG/ProfileColumnC/ProfilePoint/UIPortraitFGC" ),
	nPortraits.get_node( "HBCFG/ProfileColumnR/ProfilePoint/UIPortraitFGR" )
]

const DEFAULT_COLOR: Color = Color( 255, 255, 255, 1.0 )
const DEFAULT_WRITE_SPEED: float = 0.05
const FASTEST_WRITE_SPEED: float = 1.0 / 60.0
const DEFAULT_TYPEWRITER: String = "res://addons/gddialog/"\
		+ "assets/sounds/blip.ogg"

var reader: RefCounted = preload(
		"res://addons/gddialog/resources/res-dialog-reader.gd" )
#	Database accessors
var record_id: int
var node_id: int
var node_type: String = "Start"
var slot: int
#	Keyframes
var current_keyframe: Dictionary
var keyframes_array: Array
#	UI Properties
var write_speed: float = 0.05
var is_playing: bool = false
var is_using_default_typewriter: bool = true

#	Plugin related, not needed for example dialog to function.
var trigger_button: Button


func process_next_node() -> void:
	node_id = reader.get_node_link( record_id, node_id, slot )
	nDialogNodes.process_node()


func play_dialog( record_name: String ) -> void:
	visible = true
	emit_signal( "toggle_visible", true )
	record_id = reader.get_record_id_by_name( record_name )
	node_id = 0
	slot = 0
	node_type = "Start"
	if( nButtonNext.visible == true ):
		nButtonNext.grab_focus()
	process_next_node()


func _ready() -> void:
	reader = reader.new()
	reader.read( "res://addons/gddialog/data/baked/example.tres" )
	#	Plugin related
	trigger_button = Button.new()
	get_parent().add_child( trigger_button )
	trigger_button.text = "Play Dialog"
	trigger_button.set_anchors_and_offsets_preset( PRESET_TOP_RIGHT )
	trigger_button.connect( "pressed", Callable( 
			nSignals, "_on_trigger_button_pressed" ) )
	trigger_button.grab_focus.call_deferred()


func destroy() -> void:
	trigger_button.disconnect( "pressed", Callable( 
			nSignals, "_on_trigger_button_pressed" ) )
