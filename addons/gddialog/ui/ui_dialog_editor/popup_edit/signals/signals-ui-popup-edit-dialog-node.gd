@tool
extends Node


func _on_popup_edit_dialog_node_popup_hide():
	if( owner.nPopupEditDialogNode.nVBCNodeOptions == null ):
		return
	#	End defensive return: Child node not found.
	owner.nPopupEditDialogNode.nVBCNodeOptions.destroy()
	owner.nPopupEditDialogNode.nVBCNodeOptions = null


func _on_button_save_to_node_pressed() -> void:
	owner.nPopupEditDialogNode.save_node_data()


func _on_button_cancel_changes_pressed() -> void:
	owner.nPopupEditDialogNode.hide()


func _on_popup_edit_dialog_node_about_to_popup() -> void:
	owner.nPopupEditDialogNode.prepare_node_options()
	owner.nPopupEditDialogNode.exclusive = true
