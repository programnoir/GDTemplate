extends Node

#	Responds to changing the control scheme profile
func _on_option_button_profile_item_selected( index: int ) -> void:
	owner.nTabControls.update_profile_buttons()
	owner.nTabControls.select_input_profile( index )



func _on_button_new_profile_pressed() -> void:
	owner.nTabControls.nUIPopupCreateProfile.popup_centered()


func _on_button_save_profile_pressed() -> void:
	owner.nTabControls.save_changes_to_profile()


func _on_button_reset_profile_pressed() -> void:
	owner.nTabControls.revert_changes_to_profile()


func _on_button_delete_profile_pressed() -> void:
	owner.nTabControls.delete_current_profile()



"""
	Adding and removing keybinds.
"""


func _on_adding_bind( action: UIAction ) -> void:
	owner.nTabControls.read_new_bind_input( action )

func _on_removed_bind( action_name: String, bind: InputEvent ) -> void:
	owner.nTabControls.remove_bind_from_action( action_name, bind )

func _on_action_bind_focus_entered( vertical_position: int ) -> void:
	owner.nTabControls.scroll_to_focused_node( vertical_position )
