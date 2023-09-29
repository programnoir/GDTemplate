@tool
extends ColorRect
class_name DialogFloatRow

signal name_modified( current_name, new_name, row )
signal value_modified( float_name, new_value )
signal destroyed( row )

@onready var nLineEditFloatName: LineEdit = self.get_node( "HBoxContainer"\
		+ "/LineEditFloatName" )
@onready var nSpinBoxDefaultValue: SpinBox = self.get_node(
		"HBoxContainer/SpinBoxDefaultValue" )

var last_saved_name: String = ""


func get_float_name() -> String:
	return nLineEditFloatName.text


func set_last_saved_name( new_name: String ) -> void:
	last_saved_name = new_name


func set_name_ui( new_name: String ) -> void:
	nLineEditFloatName.text = new_name


func change_name( new_name: String ) -> void:
	if( new_name == "" ):
		set_name_ui( last_saved_name )
		return
	emit_signal( "name_modified", last_saved_name, new_name, self )


func reset_name_ui() -> void:
	nLineEditFloatName.text = last_saved_name


func set_value_ui( new_value: float ) -> void:
	nSpinBoxDefaultValue.value = new_value


func destroy() -> void:
	queue_free()
