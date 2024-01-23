@tool
extends HBoxContainer


func get_data() -> Dictionary:
	var data: Dictionary =  {
			"type": get_node( "LabelVariableType" ).text,
			"variable": get_node( "LabelVariable" ).text,
	}
	return data


func set_data( type: String, variable: String ) -> void:
	get_node( "LabelVariableType" ).text = type
	get_node( "LabelVariable" ).text = variable


func destroy() -> void:
	queue_free()
