extends Control

signal menu_settings_closed
signal new_language

@onready var nSignals: Node = get_node( "Signals" )
@onready var nSCTabsWrap: ScrollContainer = get_node(
		"VBCSettings/HBCTabs/SCTabsWrap" )
@onready var nButtonAccessibility: Button = nSCTabsWrap.get_node(
		"HBCTabsClip/ButtonAccessibility" )
@onready var nTabControls: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCControls" )
@onready var nTabAccessibility: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCAccessibility" )
@onready var nTabGameplay: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCGameplay" )
@onready var nTabVideo: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCVideo" )
@onready var nTabAudio: VBoxContainer = get_node(
		"VBCSettings/ColorRect/VBCAudio" )

#	Which button to receive focus.
var focus_button: Button


func menu_focus() -> void:
	focus_button.grab_focus()


func process_plugins() -> void:
	var plugins: Array = GlobalPlugins.request_plugins()
	for plugin in plugins:
		if( plugin.size() < 3 ):
			continue
		#	End defensive continue: Not a fit.
		if( plugin[ 0 ] is String ):
			if( plugin[ 0 ] == "settings" ):
				if( ( plugin[ 1 ] is String ) == false ):
					continue
				#	End defensive continue: Is not String.
				if( ( plugin[ 2 ] is String ) == false ):
					continue
				#	End defensive continue: Is not string.
				var new_plugin: Control = load( plugin[ 2 ] ).instantiate()
				match plugin[ 1 ]:
					"accessibility":
						nTabAccessibility.add_plugin_setting( new_plugin )
					"controls":
						nTabControls.add_plugin_setting( new_plugin )
					"gameplay":
						nTabGameplay.add_plugin_setting( new_plugin )
					"video":
						nTabVideo.add_plugin_setting( new_plugin )
					"audio":
						nTabAudio.add_plugin_setting( new_plugin )


func _ready() -> void:
	nSignals.connect_signals()
	focus_button = nButtonAccessibility
	nTabAccessibility.update_from_load()
	nTabControls.update_from_load()
	nTabVideo.update_from_load()
	nTabAudio.update_from_load()
	if( Engine.is_editor_hint() == false ):
		process_plugins()


func destroy() -> void:
	nSignals.disconnect_signals()
	nTabControls.destroy()
	if( is_queued_for_deletion() == false ):
		queue_free()
