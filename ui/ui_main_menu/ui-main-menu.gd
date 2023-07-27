extends Control

signal menu_new_game
signal menu_settings
signal menu_quit

@onready var nSignals: Node = get_node( "Signals" )
@onready var nButtonNew: Button = get_node(
		"PanelContainer/VBoxContainer/ButtonNew" )
@onready var nButtonSettings: Button = get_node(
		"PanelContainer/VBoxContainer/ButtonSettings" )

@export_file var room_game_start: String = ""

#	Defines which button to grab focus when we open this menu.
var focus_button: Button


func menu_focus() -> void:
	if( focus_button == null ):
		return
	#	End defensive return: Focus button not set.
	focus_button.grab_focus()


func retranslate() -> void:
	pass


func _ready() -> void:
	focus_button = nButtonNew
	retranslate()


func destroy() -> void:
	pass
