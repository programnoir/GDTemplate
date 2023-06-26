extends Node


func _on_ui_option_button_language_item_selected( index ) -> void:
	owner.nUITabAccessibility.set_language( index )
