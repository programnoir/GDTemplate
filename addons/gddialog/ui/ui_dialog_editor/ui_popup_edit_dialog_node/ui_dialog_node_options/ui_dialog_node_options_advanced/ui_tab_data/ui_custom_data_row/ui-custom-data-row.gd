@tool
extends HBoxContainer


func get_data() -> Variant:
	if( get_node( "SpinBoxFloat" ).visible == true ):
		return get_node( "SpinBoxFloat" ).value
	return get_node( "LineEditString" ).text


func set_data( data: Variant ) -> void:
	if( data is String ):
		get_node( "LineEditString" ).text = data
		get_node( "SpinBoxFloat" ).visible = false
	elif( data is float ):
		get_node( "SpinBoxFloat" ).value = data
		get_node( "LineEditString" ).visible = false


func destroy() -> void:
	queue_free()
