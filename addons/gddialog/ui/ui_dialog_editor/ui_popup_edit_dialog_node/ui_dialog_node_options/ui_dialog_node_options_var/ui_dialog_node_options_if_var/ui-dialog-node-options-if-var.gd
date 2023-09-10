@tool
extends DialogNodeOptionsVar
class_name DialogNodeOptionsIfVar

@onready var nOptionButtonVarType: OptionButton = get_node(
		"HBCVarTypeOptions/OptionButtonVarType" )
@onready var nOptionButtonVariable: OptionButton = get_node(
		"HBCVarOptions/OptionButtonVariable" )
@onready var nButtonDecConditions: Button = get_node(
		"HBCVarOptions/ButtonDecConditions" )
@onready var nButtonIncConditions: Button = get_node(
		"HBCVarOptions/ButtonIncConditions" )

var max_elements: int = 1
var condition_names: Array = [ "Equal to", "Greater Than", "Less Than" ]
var type: String = ""


func clear_ui() -> void:
	for child in get_children():
		if( child is LineEdit ):
			#	Strings and string arrays
			child.queue_free()
		elif( child is HBoxContainer ):
			if( child.name.contains( "HBCCondition" ) ):
				#	Float conditions
				child.queue_free()


func reset_ui() -> void:
	nButtonDecConditions.visible = ( type != "Flag" )
	nButtonIncConditions.visible = ( type != "Flag" )
	match type:
		"Flag":
			populate_options_list( nOptionButtonVariable, flags )
		"Float":
			populate_options_list( nOptionButtonVariable, floats )
		"String":
			populate_options_list( nOptionButtonVariable, strings )
		"String Array":
			populate_options_list( nOptionButtonVariable, string_arrays )


#	Complete.
func repopulate_lineedits( delta: int ) -> void:
	if( delta == -1 and max_elements == 1 ):
		return
	#	End defensive return: max_elements at minimum.
	if( delta > 0 ):
		add_child( LineEdit.new() )
	elif( delta < 0 ):
		var last_child: LineEdit = get_child( get_child_count() - 1 )
		last_child.queue_free()
	max_elements += delta


#	I *think* this is complete.
func repopulate_float_conditions( delta: int ) -> void:
	if( delta == -1 and max_elements == 1 ):
		return
	#	End defensive return: max_elements at minimum.
	if( delta > 0 ):
		var new_hbc: HBoxContainer = HBoxContainer.new()
		var new_label: Label = Label.new()
		var new_option: OptionButton = OptionButton.new()
		var new_spinbox: SpinBox = SpinBox.new()
		new_hbc.name = "HBCCondition" + str( max_elements )
		new_label.text = "Condition:"
		new_option.set_h_size_flags( SIZE_EXPAND_FILL )
		for condition in condition_names:
			new_option.add_item( condition )
		new_spinbox.allow_greater = true
		new_spinbox.allow_lesser = true
		new_spinbox.step = .001
		new_hbc.add_child( new_label )
		new_hbc.add_child( new_option )
		new_hbc.add_child( new_spinbox )
		add_child( new_hbc )
		new_option.select( 0 )
	elif( delta < 1 ):
		var last_child: HBoxContainer = get_child( get_child_count() - 1 )
		last_child.queue_free()
	max_elements += delta


#	Complete.
func _on_option_button_var_type_item_selected( index: int ) -> void:
	clear_ui()
	type = nOptionButtonVarType.get_item_text( index )
	reset_ui()
	if( type.contains( "String" ) == true ):
		repopulate_lineedits( 1 )
		max_elements = 1
	elif( type == "Float" ):
		repopulate_float_conditions( 1 )
		max_elements = 1
	else:
		#	Flag
		max_elements = 2


#	Complete.
func _on_button_dec_conditions_pressed() -> void:
	if( type == "Float" ):
		repopulate_float_conditions( -1 )
	else:
		repopulate_lineedits( -1 )


#	Complete.
func _on_button_inc_conditions_pressed() -> void:
	if( type == "Float" ):
		repopulate_float_conditions( 1 )
	else:
		repopulate_lineedits( 1 )


#	Complete
func select_by_text( option_button: OptionButton, text: String ) -> void:
	for item_id in range( 0, option_button.item_count ):
		var item_text: String = option_button.get_item_text( item_id )
		if( text == item_text ):
			option_button.select( item_id )
			return


#	Complete
func populate_ui() -> void:
	type = node_data[ "if_value_type" ]
	reset_ui()
	select_by_text( nOptionButtonVarType, node_data[ "if_value_type" ] )
	select_by_text( nOptionButtonVariable, node_data[ "if_name" ] )
	match type:
		"String", "String Array":
			max_elements = 0
			for saved_string in node_data[ "if_values" ]:
				var new_line_edit: LineEdit = LineEdit.new()
				add_child( new_line_edit )
				new_line_edit.text = saved_string
				max_elements += 1
		"Float":
			max_elements = 0
			for i in range( 0, node_data[ "if_conditions" ].size() ):
				#	Create the entries
				var new_hbc: HBoxContainer = HBoxContainer.new()
				var new_label: Label = Label.new()
				var new_option: OptionButton = OptionButton.new()
				var new_spinbox: SpinBox = SpinBox.new()
				new_hbc.name = "HBCCondition" + str( max_elements )
				new_label.text = "Condition:"
				new_option.set_h_size_flags( SIZE_EXPAND_FILL )
				for condition in condition_names:
					new_option.add_item( condition )
				new_spinbox.allow_greater = true
				new_spinbox.allow_lesser = true
				new_spinbox.step = .001
				new_hbc.add_child( new_label )
				new_hbc.add_child( new_option )
				new_hbc.add_child( new_spinbox )
				add_child( new_hbc )
				#	Populate their values
				select_by_text( new_option, node_data[ "if_conditions" ][ i ] )
				new_spinbox.value = node_data[ "if_values" ][ i ]
				max_elements += 1


#	Complete
func write_node_data() -> void:
	var changed_type: bool = false
	var previous_size: int = node_data[ "if_values" ].size()
	var preserved_link: int = -1
	if( node_data[ "if_value_type" ] != type ):
		node_data[ "if_value_type" ] = type
		changed_type = true
	#	Try to preserve No Matches link if just changing size
	if( changed_type == false ):
		if( node_data[ "links" ].has( previous_size ) ):
			preserved_link = node_data[ "links" ][ previous_size ]
	#	Proceed with writing data
	node_data[ "if_name" ] = nOptionButtonVariable.get_item_text(
				nOptionButtonVariable.selected )
	match type:
		"Flag":
			node_data[ "if_values" ] = [true].duplicate()
		"Float":
			var conditions_array: Array = []
			var values_array: Array = []
			for child in get_children():
				if( child.name.contains( "Condition" ) ):
					#	OptionButton (condition)
					var condition: OptionButton = child.get_child( 1 )
					conditions_array.append( condition.get_item_text(
							condition.selected ) )
					#	SpinBox (value)
					values_array.append( child.get_child( 2 ).value )
			node_data[ "if_conditions" ] = conditions_array.duplicate()
			node_data[ "if_values" ] = values_array.duplicate()
		"String", "String Array":
			node_data[ "if_conditions" ] = []
			var new_array: Array = []
			for child in get_children():
				if( child is LineEdit ):
					new_array.append( child.text )
			node_data[ "if_values" ] = new_array.duplicate()
	#	Copy over node link data
	var grew: bool = max_elements > previous_size
	node_data[ "slot_amount" ] = max_elements
	var replacement_links: Dictionary = {}
	var maximum_preserved_links: int = max_elements
	if( grew == true ):
		maximum_preserved_links = previous_size
	for index in range( maximum_preserved_links ):
		if( node_data[ "links" ].has( index ) ):
			replacement_links[ index ] = node_data[ "links" ][ index ]
	if( preserved_link != -1 ):
		replacement_links[ node_data[ "if_values" ].size() ] = preserved_link
	node_data[ "links" ] = replacement_links.duplicate()
