extends Node


func _on_option_button_language_item_selected( index: int ) -> void:
	owner.nTabAccessibility.set_language( index )


func _on_button_cycle_font_new_index( current_index: int ) -> void:
	owner.nTabAccessibility.set_font( current_index )
