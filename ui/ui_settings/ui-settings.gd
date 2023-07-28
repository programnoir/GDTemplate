extends Control

signal menu_settings_closed
signal new_language

@onready var nSignals: Node = get_node( "Signals" )
@onready var nButtonControls: Button = get_node(
		"VBCSettings/HBCTabs/SCTabsWrap/HBCTabsClip/ButtonControls" )
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


func menu_focus() -> void:
	focus_button.grab_focus()


func _ready() -> void:
	nSignals.connect_signals()
	focus_button = nButtonControls
	nTabAccessibility.update_from_load()
	nTabControls.update_from_load()
	nTabVideo.update_from_load()
	nTabAudio.update_from_load()


func destroy() -> void:
	nSignals.disconnect_signals()
	nTabControls.destroy()
	if( is_queued_for_deletion() == false ):
		queue_free()
