extends Node


func _on_option_button_language_item_selected( index: int ) -> void:
	owner.nTabAccessibility.set_language( index )


func _on_button_cycle_font_new_index( current_index: int ) -> void:
	owner.nTabAccessibility.set_font( current_index )


func _on_button_toggle_font_size_toggled( button_pressed: bool ) -> void:
	owner.nTabAccessibility.toggle_font_size( button_pressed )


func _on_spin_box_font_size_focus_entered() -> void:
	if( owner.nTabAccessibility.nSpinBoxFontSize.editable == false ):
		owner.nTabAccessibility.nButtonToggleFontSize.grab_focus()
