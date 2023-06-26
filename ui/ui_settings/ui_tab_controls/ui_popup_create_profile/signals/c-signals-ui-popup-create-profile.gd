extends Node



func _on_ui_popup_create_profile_about_to_popup() -> void:
	var parent: PopupPanel = get_parent()
	parent.nUILineEditProfileName.grab_focus()


func _on_ui_button_create_profile_pressed() -> void:
	var parent: PopupPanel = get_parent()
	parent.create_input_profile()


func _on_ui_button_cancel_create_profile_pressed() -> void:
	var parent: PopupPanel = get_parent()
	parent.visible = false
	parent.nUILineEditProfileName.clear()
	owner.nUITabControls.nUIButtonNewProfile.grab_focus()
