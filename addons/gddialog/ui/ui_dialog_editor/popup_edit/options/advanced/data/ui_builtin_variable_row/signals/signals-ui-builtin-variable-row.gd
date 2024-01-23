@tool
extends Node


func _on_button_delete_row_pressed() -> void:
	owner.destroy()
