extends Control

signal toggle_visible( visibility: bool )

@onready var nSignals: Node = get_node( "Signals" )
@onready var nDialogNodes: Node = get_node( "DialogNodes" )
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
@onready var nButtonNext: Button = nHBCDialog.get_node(
		"VBCButtons/ButtonNext" )

var reader: RefCounted = preload(
		"res://addons/gddialog/resources/res-dialog-reader.gd" )
#	Database accessors
var record_id: int
var node_id: int
var node_type: String = "Start"
var slot: int
#	UI Properties
var write_speed: float = 0.05
var is_playing: bool = false

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
