extends Node



func _on_ui_popup_create_profile_about_to_popup() -> void:
	var parent: PopupPanel = get_parent()
	parent.nLineEditProfileName.grab_focus()


func _on_button_create_profile_pressed() -> void:
	var parent: PopupPanel = get_parent()
	parent.create_input_profile()


func _on_button_cancel_create_profile_pressed() -> void:
	var parent: PopupPanel = get_parent()
	parent.visible = false
	parent.nLineEditProfileName.clear()
	owner.nTabControls.nButtonNewProfile.grab_focus()
