@tool
extends DialogVariableNode
class_name DialogVariableIfNode

var slot_count: int = 2


""" Signals """


func _on_ui_dialog_node_close_request() -> void:
	super()


func _on_ui_dialog_node_position_offset_changed() -> void:
	super()


func _on_ui_dialog_node_resize_request( new_minsize: Vector2 ) -> void:
	super( new_minsize )


""" Slot Management """


func set_slot_count( new_amount: int ) -> void:
	slot_count = new_amount


func get_slot_count() -> int:
	return slot_count


func clear_link_labels() -> void:
	var children = get_children()
	for child in children:
		if( child is Label ):
			child.free()


""" Updating Slots """


func update_slots() -> void:
	#	GraphNode function
	clear_all_slots()
	#	Referenced earlier
	clear_link_labels()
	#	Add slots and labels.
	for slot in range( 0, slot_count ):
		set_slot( slot, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
		var output_link_label: Label = Label.new()
		add_child( output_link_label )
		move_child( output_link_label, slot )
		#	This will need to be updated
		output_link_label.text = str( slot )
		output_link_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	set_slot_enabled_left( 0, true )


""" Data population """


func add_label( text: String ) -> void:
	var output_link_label: Label = Label.new()
	add_child( output_link_label )
	output_link_label.text = text
	output_link_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT


func populate_node_data( node_data: Dictionary ) -> void:
	slot_count = node_data[ "if_values" ].size()
	if( slot_count == 0 ):
		set_summary( "" )
		return
	#	End defensive return: Quit trying to break the plugin!
	clear_all_slots()
	clear_link_labels()
	set_slot( 0, true, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
	if( node_data[ "if_value_type" ] == "Flag" ):
		slot_count = 2
		set_summary( "Flag " + node_data[ "if_name" ] + " == true" )
		add_label( "False" )
		set_slot( 1, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
		return
	#	Done with flag variable.
	#	Setting the summary variable
	var summary_info: String = node_data[ "if_value_type" ] + " " \
			+ node_data[ "if_name" ]
	match node_data[ "if_value_type" ]:
			"Float":
				summary_info += "\n" + node_data[ "if_conditions" ][ 0 ] \
				+ " " + str( node_data[ "if_values" ][ 0 ] )
			"String":
				summary_info += "\n== " + node_data[ "if_values" ][ 0 ]
			"String Array":
				#	This is for an *exact* variable match.
				for string_entry in node_data[ "if_values" ]:
					summary_info += "\n" + string_entry
				set_summary( summary_info )
				add_label( "Does Not Match" )
				set_slot( 1, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
						true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
				resize_node( Vector2( 0, 0 ) )
				return
			#	End defensive return: String array handled
	set_summary( summary_info )
	if( slot_count == 1 ):
		add_label( "No Matches" )
		set_slot( slot_count, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
		resize_node( Vector2( 0, 0 ) )
		return
	#	End defensive return: No other values set.
	for slot in range( 1, slot_count ):
		set_slot( slot, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
		#	This will need to be updated
		match node_data[ "if_value_type" ]:
			"Float":
				summary_info = node_data[ "if_conditions" ][ slot ] \
				+ " " + str( node_data[ "if_values" ][ slot ] )
			"String":
				summary_info = "== " + node_data[ "if_values" ][ slot ]
		add_label( summary_info )
	add_label( "No Matches" )
	set_slot( slot_count, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
	resize_node( Vector2( 0, 0 ) )
