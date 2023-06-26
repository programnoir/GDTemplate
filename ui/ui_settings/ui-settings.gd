extends Control

@onready var cSig: Node = $cSig
@onready var nUIButtonControls: Button = get_node(
		"VBCSettings/HBCTabs/HBCClip/UIButtonControls" )
@onready var nUITabControls: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCControls" )
@onready var nUITabAccessibility: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCAccessibility" )
@onready var nUITabVideo: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCVideo" )
@onready var nUITabAudio: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCAudio" )

var focus_button: Button
var current_tab: int = 0
var loaded_settings: bool = false

signal menu_settings_closed
signal new_language


func menu_focus() -> void:
	focus_button.grab_focus()


func _enter_tree() -> void:
	loaded_settings = UserSettings.load_settings()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_button = nUIButtonControls
	#	Load settings once called. We'll add a first-time setup menu as well.
	if( loaded_settings ):
		#	Load from settings.
		nUITabAccessibility.update_from_load()
		nUITabControls.update_from_load()
		nUITabVideo.update_from_load()
		nUITabAudio.update_from_load()
	else:
		nUITabVideo.initialize_video_settings()
		nUITabControls.populate_action_list()


func destroy() -> void:
	nUITabControls.destroy()
	if( is_queued_for_deletion() == false ):
		queue_free()
