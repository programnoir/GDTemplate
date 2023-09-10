@tool
extends DialogNodeOptionsVar
class_name DialogNodeOptionsSetVar

@onready var nOptionButtonVarType: OptionButton = get_node(
		"HBCVarTypeOptions/OptionButtonVarType" )
@onready var nOptionButtonVariable: OptionButton = get_node(
		"HBCVarOptions/OptionButtonVariable" )
@onready var nOptionButtonFlag: OptionButton = get_node(
		"HBCVarOptions/OptionButtonFlag" )
@onready var nSpinBoxFloat: SpinBox = get_node( "HBCVarOptions/SpinBoxFloat" )
@onready var nLineEditString: LineEdit = get_node(
		"HBCVarOptions/LineEditString" )
@onready var nButtonDecreaseArray: Button = get_node(
		"HBCVarOptions/ButtonDecreaseArray" )
@onready var nButtonIncreaseArray: Button = get_node(
		"HBCVarOptions/ButtonIncreaseArray" )

var max_elements: int = 1
var type: String = ""


func _on_option_button_var_type_item_selected( index: int ) -> void:
	clear_string_array_lineedits()
	type = nOptionButtonVarType.get_item_text( index )
	reset_ui()
	if( type == "String Array" ):
		repopulate_lineedits( 1 )
		max_elements = 1


func _on_button_decrease_array_pressed() -> void:
	repopulate_lineedits( -1 )


func _on_button_increase_array_pressed() -> void:
	repopulate_lineedits( 1 )


func reset_ui() -> void:
	nOptionButtonFlag.visible = ( type == "Flag" )
	nSpinBoxFloat.visible = ( type == "Float" )
	nLineEditString.visible = ( type == "String" )
	nButtonDecreaseArray.visible = ( type == "String Array" )
	nButtonIncreaseArray.visible = ( type == "String Array" )
	match type:
		"Flag":
			populate_options_list( nOptionButtonVariable, flags )
		"Float":
			populate_options_list( nOptionButtonVariable, floats )
		"String":
			populate_options_list( nOptionButtonVariable, strings )
		"String Array":
			populate_options_list( nOptionButtonVariable, string_arrays )


func populate_ui() -> void:
	type = node_data[ "set_value_type" ]
	reset_ui()
	for variable_name_id in range( 0, nOptionButtonVariable.item_count ):
		var current_name: String = nOptionButtonVariable.get_item_text(
				variable_name_id )
		if( node_data[ "set_name" ] == current_name ):
			nOptionButtonVariable.select( variable_name_id )
			break
	match type:
		"Flag":
			if( node_data[ "set_value" ] == true ):
				nOptionButtonFlag.select( 1 )
			else:
				nOptionButtonFlag.select( 0 )
		"Float":
			nSpinBoxFloat.value = node_data[ "set_value" ]
		"String":
			nLineEditString.text = node_data[ "set_value" ]
		"String Array":
			max_elements = 0
			for saved_string in string_arrays:
				var new_line_edit: LineEdit = LineEdit.new()
				add_child( new_line_edit )
				new_line_edit.text = saved_string
				max_elements += 1


func write_node_data() -> void:
	node_data[ "set_value_type" ] = type
	node_data[ "set_name" ] = nOptionButtonVariable.get_item_text(
				nOptionButtonVariable.selected )
	match type:
		"Flag":
			node_data[ "set_value" ] = ( nOptionButtonFlag.selected == 1 )
		"Float":
			node_data[ "set_value" ] = nSpinBoxFloat.value
		"String":
			node_data[ "set_value" ] = nLineEditString.text
		"String Array":
			var new_array: Array = []
			for child in get_children():
				if( child is LineEdit ):
					new_array.append( child.text )
			node_data[ "set_value" ] = new_array.duplicate()


func repopulate_lineedits( delta: int ) -> void:
	if( delta == -1 and max_elements == 1 ):
		return
	#	End defensive return: max_elements at minimum.
	if( delta > 0 ):
		add_child( LineEdit.new() )
	elif( delta < 1 ):
		var last_child: LineEdit = get_child( get_child_count() - 1 )
		last_child.queue_free()
	max_elements += delta


func clear_string_array_lineedits() -> void:
	for child in get_children():
		if( child is LineEdit ):
			child.queue_free()
	max_elements = 1

