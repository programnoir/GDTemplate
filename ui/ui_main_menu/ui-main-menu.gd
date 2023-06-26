extends Control

@onready var cSig: Node = $cSig
@onready var nUIButtonNew: Button = get_node(
		"Panel/CenterContainer/VBoxContainer/UIButtonNew" )
@onready var nUIButtonSettings: Button = get_node(
		"Panel/CenterContainer/VBoxContainer/UIButtonSettings" )

@export_file var room_game_start: String = ""

var focus_button: Button

signal menu_new_game
signal menu_settings
signal menu_quit


func menu_focus() -> void:
	if( focus_button == null ):
		return
	focus_button.grab_focus()


func retranslate() -> void:
	#	Buttons are not necessary!
	#nUIButtonNew.text = tr( "ui_new_game" )
	pass


func _ready() -> void:
	focus_button = nUIButtonNew
	retranslate()

func destroy() -> void:
	pass
