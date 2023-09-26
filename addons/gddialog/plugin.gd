@tool
extends EditorPlugin

const TRANSLATION_PATHS: Array = [
	"res://addons/gddialog/data/translations/gddialog-translations.en.translation",
	"res://addons/gddialog/data/translations/gddialog-translations.ja.translation"
]
var n_UIDatabaseEditor: Control
var n_UIDialogEditor: Control
var n_ButtonDatabaseEditor: Button
var n_ButtonDialogEditor: Button
var setting_text_speed: String = "res://addons/gddialog"\
		+ "/ui/ui_settings_text_speed/ui-settings-text-speed.tscn"

var p_UIDatabaseEditor: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui-dialog-database-editor.tscn" )
var p_UIDialogEditor: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_dialog_editor/ui-dialog-editor.tscn" )


func _enter_tree() -> void:
	n_UIDatabaseEditor = p_UIDatabaseEditor.instantiate()
	n_UIDialogEditor = p_UIDialogEditor.instantiate()
	n_UIDatabaseEditor.connect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	n_UIDialogEditor.connect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	#	This instances the toggle label in the bottom bar for the record editor.
	n_ButtonDatabaseEditor = add_control_to_bottom_panel( n_UIDatabaseEditor,
			"Dialog Records" )
	n_ButtonDialogEditor = add_control_to_bottom_panel( n_UIDialogEditor,
			"Dialog Editor" )
	n_ButtonDialogEditor.visible = false
	#	This creates a relationship between the database and dialog editors.
	n_UIDatabaseEditor.set_dialog_editor( n_UIDialogEditor )


func _ready() -> void:
	GlobalPlugins.add_plugin_to_list( [ "settings", "accessibility", 
			setting_text_speed ] )
	GlobalPlugins.add_plugin_to_list( [ "first_setup", "accessibility", 
			setting_text_speed ] )
	for translation in TRANSLATION_PATHS:
		GlobalPlugins.add_translation( translation )


func switch_bottom_panel_control() -> void:
	var toggle: bool = n_ButtonDatabaseEditor.visible
	n_ButtonDatabaseEditor.visible = not toggle
	n_ButtonDialogEditor.visible = toggle
	#	Flip the visibility of the panels.
	n_UIDatabaseEditor.visible = not toggle
	n_UIDialogEditor.visible = toggle
	#	Flip the "pressed" property of the buttons.
	n_ButtonDatabaseEditor.button_pressed = not toggle
	n_ButtonDialogEditor.button_pressed = toggle


func _exit_tree() -> void:
	GlobalPlugins.erase_plugin_from_list( [ "settings", "accessibility", 
			setting_text_speed ] )
	GlobalPlugins.erase_plugin_from_list( [ "first_setup", "accessibility", 
			setting_text_speed ] )
	for translation in TRANSLATION_PATHS:
		GlobalPlugins.remove_translation( translation )
	n_UIDialogEditor.disconnect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	n_UIDatabaseEditor.disconnect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	n_UIDialogEditor.destroy()
	n_UIDatabaseEditor.destroy()
	#	Remove the instance from the controls from the bottom bar.
	remove_control_from_bottom_panel( n_UIDialogEditor )
	remove_control_from_bottom_panel( n_UIDatabaseEditor )
	n_UIDialogEditor.queue_free()
	n_UIDatabaseEditor.queue_free()
