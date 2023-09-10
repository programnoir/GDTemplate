@tool
extends Node


func _on_button_add_animation_pressed() -> void:
	owner.nTabAnimations.add_animation_row()
