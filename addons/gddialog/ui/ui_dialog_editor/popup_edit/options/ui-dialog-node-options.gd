@tool
extends VBoxContainer
class_name DialogNodeOptions

var node_data: Dictionary = {}


""" Save/Cancel Options """


func set_node_data( new_data: Dictionary ) -> void:
	node_data = new_data.duplicate()


#	Gets overridden
func write_node_data() -> void:
	pass


func get_node_data() -> Dictionary:
	write_node_data()
	return node_data


#	Gets overridden
func populate_ui() -> void:
	pass


func destroy() -> void:
	queue_free()
