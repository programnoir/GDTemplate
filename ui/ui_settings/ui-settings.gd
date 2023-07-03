extends Control

signal menu_settings_closed
signal new_language

@onready var nSignals: Node = get_node( "Signals" )
@onready var nButtonControls: Button = get_node(
		"VBCSettings/HBCTabs/HBCClip/ButtonControls" )
@onready var nTabControls: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCControls" )
@onready var nTabAccessibility: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCAccessibility" )
@onready var nTabVideo: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCVideo" )
@onready var nTabAudio: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCAudio" )

#	Which button to receive focus.
var focus_button: Button
#	Set to true if settings have been configured before.
var loaded_settings: bool = false


func menu_focus() -> void:
	focus_button.grab_focus()


func _enter_tree() -> void:
	loaded_settings = GlobalUserSettings.load_settings()


func _ready() -> void:
	focus_button = nButtonControls
	if( loaded_settings ):
		#	Load from settings.
		nTabAccessibility.update_from_load()
		nTabControls.update_from_load()
		nTabVideo.update_from_load()
		nTabAudio.update_from_load()
	else:
		nTabVideo.initialize_video_settings()
		nTabControls.populate_action_list()


func destroy() -> void:
	nTabControls.destroy()
	if( is_queued_for_deletion() == false ):
		queue_free()
