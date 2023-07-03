extends Node


func _on_option_button_language_item_selected( index: int ) -> void:
	owner.nTabAccessibility.set_language( index )
