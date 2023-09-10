@tool
#	Enters tool mode. Has to be at the top.
#	We're making a plugin for the editor, hence we extend from that class.
extends EditorPlugin


var n_UIDatabaseEditor: Control
var n_UIDialogEditor: Control
var n_ButtonDatabaseEditor: Button
var n_ButtonDialogEditor: Button


var p_UIDatabaseEditor: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui-dialog-database-editor.tscn" )
var p_UIDialogEditor: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_dialog_editor/ui-dialog-editor.tscn" )


""" _enter_tree()
Description:
	As soon as the plugin is loaded into the editor, we'll want to accomplish
	 a few things. We want a database editor and a dialog record editor. Both
	 will have to be initiated. Because we will have to do some manual memory
	 management, the enter and exit functions will be kept close together.
"""
func _enter_tree() -> void:
	#	Instance the database editor into Godot's bottom bar.
	n_UIDatabaseEditor = p_UIDatabaseEditor.instantiate()
	#	Instance the dialog editor into Godot's bottom bar.
	n_UIDialogEditor = p_UIDialogEditor.instantiate()
	
	#	These signals are for switching back and forth between the editors.
	n_UIDatabaseEditor.connect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	n_UIDialogEditor.connect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	#	This instances the toggle label in the bottom bar for the record editor.
	n_ButtonDatabaseEditor = self.add_control_to_bottom_panel(
			n_UIDatabaseEditor, "Dialog Records" )
	n_ButtonDialogEditor = self.add_control_to_bottom_panel(
			n_UIDialogEditor, "Dialog Editor" )
	#	By default, the dialog editor is hidden.
	n_ButtonDialogEditor.visible = false
	#	This creates a relationship between the database and dialog editors.
	n_UIDatabaseEditor.set_dialog_editor( n_UIDialogEditor )
	#n_UIDialogEditor.set_database_editor( n_UIDatabaseEditor )


func switch_bottom_panel_control() -> void:
	#	Flip the visibility of the control buttons.
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
	#	Disconnect the switch signal.
	n_UIDialogEditor.disconnect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	n_UIDatabaseEditor.disconnect( "switch_control", Callable( self,
			"switch_bottom_panel_control" ) )
	#	Remove the record editor from Godot.
	n_UIDialogEditor.destroy()
	n_UIDatabaseEditor.destroy()
	#	Remove the instance from the controls from the bottom bar.
	remove_control_from_bottom_panel( n_UIDialogEditor )
	remove_control_from_bottom_panel( n_UIDatabaseEditor )
	#	The instance has to be queue_free()'d, or you'll get leaks and weird
	#	 "nonexistent signal" garbage piling up in your output!
	#	 This is 100% the right way to do this.
	n_UIDialogEditor.queue_free()
	n_UIDatabaseEditor.queue_free()
