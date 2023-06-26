extends Node




func _on_adding_bind( action: UIAction ) -> void:
	owner.nUITabControls.read_new_bind_input( action )

func _on_removed_bind( action_name: String, bind: InputEvent ) -> void:
	owner.nUITabControls.remove_bind_from_action( action_name, bind )

func _on_ui_button_close_settings_pressed():
	owner.emit_signal( "menu_settings_closed" )

func _on_action_bind_focus_entered( vertical_position: int ) -> void:
	owner.nUITabControls.scroll_to_focused_node( vertical_position )
