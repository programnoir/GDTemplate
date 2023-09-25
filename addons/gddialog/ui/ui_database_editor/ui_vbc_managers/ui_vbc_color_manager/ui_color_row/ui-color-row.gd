@tool
extends ColorRect
class_name DialogColorRow

signal name_modified( current_name, new_name, row )
signal value_modified( color_name, new_value )
signal destroyed( row )

@onready var nLineEditColorName: LineEdit = self.get_node( "HBoxContainer"\
		+ "/LineEditColorName" )
@onready var nColorPickerButton: ColorPickerButton = self.get_node(
		"HBoxContainer/ColorPickerButton" )

var last_saved_name: String = ""


func get_color_name() -> String:
	return nLineEditColorName.text


func set_last_saved_name( new_name: String ) -> void:
	last_saved_name = new_name


func set_name_ui( new_name: String ) -> void:
	nLineEditColorName.text = new_name


func change_name( new_name: String ) -> void:
	if( new_name == "" ):
		set_name_ui( last_saved_name )
		return
	emit_signal( "name_modified", last_saved_name, new_name, self )


func reset_name_ui() -> void:
	nLineEditColorName.text = last_saved_name


func set_value_ui( new_value: Color ) -> void:
	nColorPickerButton.color = new_value


func destroy() -> void:
	queue_free()

