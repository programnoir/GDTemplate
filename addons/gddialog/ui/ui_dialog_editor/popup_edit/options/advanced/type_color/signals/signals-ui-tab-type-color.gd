@tool
extends Node


func _on_option_button_color_item_selected( index: int ) -> void:
	get_parent().select_color( index )
