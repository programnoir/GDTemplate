@tool
extends ColorRect
class_name DialogStringRow

signal name_modified( current_name, new_name, row )
signal value_modified( string_name, new_value )
signal destroyed( row )

@onready var nLineEditStringName: LineEdit = self.get_node( "HBoxContainer"\
		+ "/LineEditStringName" )
@onready var nLineEditDefaultValue: LineEdit = self.get_node(
		"HBoxContainer/LineEditDefaultValue" )

var last_saved_name: String = ""
var last_saved_value: String = ""

func get_string_name() -> String:
	return nLineEditStringName.text


func set_last_saved_name( new_name: String ) -> void:
	last_saved_name = new_name


func set_name_ui( new_name: String ) -> void:
	nLineEditStringName.text = new_name


func change_name( new_name: String ) -> void:
	if( new_name == "" ):
		set_name_ui( last_saved_name )
		return
	emit_signal( "name_modified", last_saved_name, new_name, self )


func reset_name_ui() -> void:
	nLineEditStringName.text = last_saved_name


func set_value_ui( new_value: String ) -> void:
	nLineEditDefaultValue.text = new_value


func destroy() -> void:
	queue_free()

