extends Control

@onready var nSignals: Node = get_node( "Signals" )
@onready var nGame: Node = get_node( "Game" )
@onready var nUI: Control = get_node( "UI" )
#@onready var nUIMainMenu: Control = nUI.get_node( "UIMainMenu" )
#@onready var nUISettings: Control = nUI.get_node( "UISettings" )

var pUIFirstSetup: PackedScene = preload(
		"res://ui/ui_first_setup/ui-first-setup.tscn" )
var pUIMainMenu: PackedScene = preload(
		"res://ui/ui_main_menu/ui-main-menu.tscn" )
var pUISettings: PackedScene = preload(
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
	nUIMainMenu = pUIMainMenu.instantiate()
	nUISettings = pUISettings.instantiate()
	nUI.add_child( nUIMainMenu )
	nUI.add_child( nUISettings )
	#	Enable if developing for mobile.
	#get_tree().set_auto_accept_quit( false )
	nUIMainMenu.visible = true
	nUISettings.visible = false
	#	New Game
	nUIMainMenu.menu_new_game.connect(
			Callable( nSignals, "_on_menu_new_game" ) )
	#	Continue Game
	#	Settings
	nUIMainMenu.menu_settings.connect(
			Callable( nSignals, "_on_menu_settings" ) )
	nUISettings.new_language.connect(
			Callable( nSignals, "_on_new_language" ) )
	nUISettings.menu_settings_closed.connect(
			Callable( nSignals, "_on_menu_settings_closed" ) )
	#	Quit
	nUIMainMenu.menu_quit.connect( Callable( nSignals, "_on_menu_quit" ) )
	nUIMainMenu.menu_focus()
	print( nUIMainMenu )


func _ready() -> void:
	#	Need to know if we've configured settings before.
	#	Config files will be located in:
	#	%AppData%\Roaming\Godot\app_userdata\GDTemplate
	if( loaded_settings == false ):
		GlobalUserSettings.set_first_time_setup( false )
	#	If we couldn't find the loaded files or if you saw the menu already:
	if( GlobalUserSettings.first_time_setup == false ):
		nUIFirstSetup = pUIFirstSetup.instantiate()
		nUI.add_child( nUIFirstSetup )
		nUIFirstSetup.new_language.connect(
				Callable( nSignals, "_on_new_language" ) )
		nUIFirstSetup.completed_first_setup.connect(
				Callable( nSignals, "_on_completed_first_setup" ) )
	else:
		add_main_menus()
	#	Mainly have to do this just so that the language adjusts correctly.
	TranslationServer.set_locale(
			GlobalUserSettings.accessibility[ "current_language" ] )


func destroy() -> void:
	#	Should run all destroy functions that can be located in game.
	if( nUIFirstSetup != null ):
		nUIFirstSetup.disconnect_first_setup_signals()
		nUIFirstSetup.destroy()
	if( nUIMainMenu != null ):
		nUIMainMenu.menu_new_game.disconnect(
				Callable( nSignals, "_on_menu_new_game" ) )
		nUIMainMenu.menu_settings.disconnect( 
				Callable( nSignals, "_on_menu_settings" ) )
		nUIMainMenu.menu_quit.disconnect( Callable( nSignals, "_on_menu_quit" ) )
		nUIMainMenu.destroy()
	if( nUISettings != null ):
		nUISettings.new_language.disconnect(
				Callable( nSignals, "_on_new_language" ) )
		nUISettings.menu_settings_closed.disconnect(
				Callable( nSignals, "_on_menu_settings_closed" ) )
		nUISettings.destroy()
	#	Any awaits go here.
	get_tree().quit( 0 )
