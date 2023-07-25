extends Control

signal translation_complete

@onready var nSignals: Node = get_node( "Signals" )
@onready var nGame: Node = get_node( "Game" )
@onready var nUI: Control = get_node( "UI" )

var p_UIFirstSetup: PackedScene = preload(
		"res://ui/ui_first_setup/ui-first-setup.tscn" )
var p_UIMainMenu: PackedScene = preload(
		"res://ui/ui_main_menu/ui-main-menu.tscn" )
var p_UISettings: PackedScene = preload(
		"res://ui/ui_settings/ui-settings.tscn" )

var nUIFirstSetup: Control = null
var nUIMainMenu: Control = null
var nUISettings: Control = null

#	Tracks which menu (Main menu, pause menu) preceded the Settings menu.
var previous_menu: Control
var loaded_settings: bool = false


func _enter_tree() -> void:
	loaded_settings = GlobalUserSettings.load_settings()


func add_main_menus() -> void:
	nUIMainMenu = p_UIMainMenu.instantiate()
	nUISettings = p_UISettings.instantiate()
	nUI.add_child( nUIMainMenu )
	nUI.add_child( nUISettings )
	nSignals.connect_main_menu_signals()
	nSignals.connect_settings_signals()
	nUIMainMenu.visible = true
	nUISettings.visible = false
	nUISettings.send_font_signal()
	nUIMainMenu.menu_focus()


func _ready() -> void:
	#	Enable if developing for mobile.
	#get_tree().set_auto_accept_quit( false )
	#	Need to know if we've configured settings before.
	#	Config files will be located in:
	#	%AppData%\Roaming\Godot\app_userdata\GDTemplate
	if( loaded_settings == false ):
		GlobalUserSettings.set_first_time_setup( false )
	#	If we couldn't find the loaded files or if you saw the menu already:
	if( GlobalUserSettings.first_time_setup == false ):
		nUIFirstSetup = p_UIFirstSetup.instantiate()
		nUI.add_child( nUIFirstSetup )
		nSignals.connect_first_setup_signals()
	else:
		add_main_menus()
	#	Mainly have to do this just so that the language adjusts correctly.
	TranslationServer.set_locale(
			GlobalUserSettings.accessibility[ "current_language" ] )


func destroy() -> void:
	#	Should run all destroy functions that can be located in game.
	if( nUIFirstSetup != null ):
		nSignals.disconnect_first_setup_signals()
		nUIFirstSetup.destroy()
	if( nUIMainMenu != null ):
		nSignals.disconnect_main_menu_signals()
		nUIMainMenu.destroy()
	if( nUISettings != null ):
		nSignals.disconnect_settings_signals()
		nUISettings.destroy()
	#	Any awaits go here.
	get_tree().quit( 0 )
