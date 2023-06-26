extends Node

#	Responds to changing the control scheme profile
func _on_ui_option_button_profile_item_selected( index: int ) -> void:
	owner.nUITabControls.update_profile_buttons()
	owner.nUITabControls.select_input_profile( index )



func _on_ui_button_new_profile_pressed() -> void:
	owner.nUITabControls.nUIPopupCreateProfile.popup_centered()


func _on_ui_button_save_profile_pressed() -> void:
	owner.nUITabControls.save_changes_to_profile()


func _on_ui_button_reset_profile_pressed() -> void:
	owner.nUITabControls.revert_changes_to_profile()


func _on_ui_button_delete_profile_pressed() -> void:
	owner.nUITabControls.delete_current_profile()



"""
	Adding and removing keybinds.
"""


func _on_adding_bind( action: UIAction ) -> void:
	owner.nUITabControls.read_new_bind_input( action )

func _on_removed_bind( action_name: String, bind: InputEvent ) -> void:
	owner.nUITabControls.remove_bind_from_action( action_name, bind )

func _on_action_bind_focus_entered( vertical_position: int ) -> void:
	owner.nUITabControls.scroll_to_focused_node( vertical_position )
