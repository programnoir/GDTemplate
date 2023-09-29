@tool
extends Node

var n_Database: Node = null
var database: Dictionary = {}


func set_references() -> void:
	n_Database = get_parent()
	database = n_Database.database


""" Node Operations """


func generate_node_id( record_id: int ) -> int:
	if( database[ record_id ][ "available_node_ids" ].size() != 0 ):
		return database[ record_id ][ "available_node_ids" ].pop_front()
	else:
		return database[ record_id ][ "nodes" ].size()


func create_node( record_id: int, type: String ) -> int:
	var new_node_id = generate_node_id( record_id )
	var node_data: Dictionary = {
			"type": type,
			"graph_offset": Vector2( 80, 80 ),
			"rect_size": Vector2( 0, 0 ),
			"vbc_size": Vector2( 0, 0 ),
			"links": {},
			"slot_amount": 1
	}
	match( type ):
		"Line":
			node_data[ "text" ] = ""
			node_data[ "speaker" ] = ""
		"Advanced":
			node_data[ "speaker" ] = ""
			node_data[ "keyframes" ] = []
		"Set":
			node_data[ "set_name" ] = "Not Set"
			node_data[ "set_value_type" ] = "Flag"
			node_data[ "set_value" ] = false
		"If":
			node_data[ "if_name" ] = "Not Set"
			node_data[ "if_value_type" ] = "Flag"
			#	Names of conditions to test (Number only)
			node_data[ "if_conditions" ] = []
			#	Array of values to test (Flag only has one entry)
			node_data[ "if_values" ] = [true]
		"Set GUI":
			node_data[ "gui_type" ] = ""
		"Run Script":
			node_data[ "script_filepath" ] = ""
			node_data[ "script_funcref" ] = ""
	database[ record_id ][ "nodes" ][ new_node_id ] = node_data
	owner.set_filename_label_modified( true )
	return new_node_id


""" Node Arrays (IDs and Links) """


func get_record_node_ids( record_id: int ) -> Array:
	return database[ record_id ][ "nodes" ].keys()


func get_node_links( record_id: int, node_id: int ) -> Array:
	return database[ record_id ][ "nodes" ][ node_id ][ "links" ].keys()


""" Adjusting Properties """


func get_node_data( record_id: int, node_id: int ) -> Dictionary:
	return database[ record_id ][ "nodes" ][ node_id ]


func set_node_data(
		record_id: int,
		node_id: int,
		new_data: Dictionary
) -> void:
	database[ record_id ][ "nodes" ][ node_id ] = new_data.duplicate( true )


""" Node Properties """


func set_node_property(
	record_id: int,
	node_id: int,
	property: String,
	data
) -> void:
	owner.set_filename_label_modified( true )
	database[ record_id ][ "nodes" ][ node_id ][ property ] = data


func get_node_property(
	record_id: int,
	node_id: int,
	property: String
) -> Variant:
	return database[ record_id ][ "nodes" ][ node_id ][ property ]


func push_node_property_slot(
	record_id: int,
	node_id: int,
	property: String,
	data
) -> void:
	database[ record_id ][ "nodes" ][ node_id ][ property ].push_back( data )


func set_node_property_slot(
	record_id: int,
	node_id: int,
	property: String,
	slot: int,
	data
) -> void:
	database[ record_id ][ "nodes" ][ node_id ][ property ][ slot ] = data


func get_node_property_slot(
	record_id: int,
	node_id: int,
	property: String,
	slot: int
):
	return database[ record_id ][ "nodes" ][ node_id ][ property ][ slot ]


func delete_node_property_slot(
	record_id: int,
	node_id: int,
	property: String,
	slot: int
) -> void:
	if( database[ record_id ][ "nodes" ][ node_id ][ property ] is Array ):
		if( slot < database[ record_id ][ "nodes" ][ node_id ]\
				[ property ].size()
		):
			database[ record_id ][ "nodes" ]\
					[ node_id ][ property ].remove( slot )
	elif( database[ record_id ][ "nodes" ][ node_id ][ property ].has( slot ) ):
		database[ record_id ][ "nodes" ][ node_id ][ property ].erase( slot )


""" Node Data Information """


func modify_variable_in_keyframes(
		node: Dictionary,
		type: String,
		var_name: String,
		replacement: String = ""
) -> void:
	for keyframe in node[ "keyframes" ]:
		if( type == "Color" ):
			if( keyframe[ "text_color" ] == var_name ):
				if( replacement != "" ):
					keyframe[ "text_color" ] = replacement
					continue
				#	End defensive continue
				keyframe[ "text_color" ] = "Custom"
				keyframe[ "text_color_custom" ] = Color( 0.0, 0.0, 0.0, 1.0 )
		else:
			var erasure_data: Array = []
			for data in keyframe[ "variable_data" ]:
				if( data[ "type" ] != type ):
					continue
				if( data[ "variable" ] != var_name ):
					continue
				#	End defensive continues
				if( replacement == "" ):
					erasure_data.append( data.duplicate( true ) )
				else:
					data[ "variable" ] = replacement
			for data in erasure_data:
				keyframe[ "variable_data" ].erase( data )


func modify_variable_in_nodes(
	type: String,
	var_name: String,
	replacement: String = ""
) -> void:
	for record in database:
		for node in database[ record ][ "nodes" ]:
			var node_data: Dictionary = database[ record ][ "nodes" ][ node ]
			if( node_data[ "type" ] == "If" ):
				if( node_data[ "if_value_type" ] != type ):
					continue
				if( node_data[ "if_name" ] != var_name ):
					continue
				#	End defensive continues
				var new_name: String = replacement
				if( new_name == "" ):
					new_name = "Not Set"
				set_node_property( record, node, "if_name", new_name )
			elif( node_data[ "type" ] == "Set" ):
				if( node_data[ "set_value_type" ] != type ):
					continue
				if( node_data[ "set_name" ] != var_name ):
					continue
				#	End defensive continues
				var new_name: String = replacement
				if( new_name == "" ):
					new_name = "Not Set"
				set_node_property( record, node, "set_name", new_name )
			elif( type == "Speaker" ):
				if( node_data[ "type" ] == "Advanced"
						|| node_data[ "type" ] == "Line"
				):
					if( node_data[ "speaker" ] == var_name ):
						node_data[ "speaker" ] = replacement
			elif( node_data[ "type" ] == "Advanced" ):
				if( [ "Float", "String", "Flag", "Color" ].has( type ) ):
					modify_variable_in_keyframes( node_data, type,
							var_name, replacement )


""" Node Links """


func set_node_link(
	record_id: int,
	from_id: int,
	from_slot: int,
	to_id: int
) -> void:
	database[ record_id ][ "nodes" ][ from_id ][ "links" ]\
			[ from_slot ] = to_id
	owner.set_filename_label_modified( true )


func get_node_link( record_id: int, node_id: int, slot: int ) -> int:
	if( database[ record_id ][ "nodes" ][ node_id ]\
			[ "links" ].has( slot ) == false ):
		return -1
	#	End defensive return
	return database[ record_id ][ "nodes" ][ node_id ][ "links" ][ slot ]


""" Erasing Links """


#	For erasing just one link in a node.
func erase_link_in_node( record_id: int, from_id: int, slot: int ) -> void:
	database[ record_id ][ "nodes" ][ from_id ][ "links" ].erase( slot )
	owner.set_filename_label_modified( true )


#	Search for a node (id) in every node's links and erase matching links.
func erase_all_links_to_node( record_id: int, dest_node_id: int ) -> void:
	var node_ids: Array = get_record_node_ids( record_id )
	#	Iterate through all of the nodes
	for node_id in node_ids:
		var node_slots: Array = get_node_links( record_id, node_id )
		#	Iterate through all of the links in each node.
		for slot in node_slots:
			var to_node_id: int = get_node_link( record_id, node_id, slot )
			if( to_node_id == dest_node_id ):
				erase_link_in_node( record_id, node_id, slot )
	owner.set_filename_label_modified( true )


#	Erase all links of this record's node.
func erase_all_links_in_node( record_id: int, node_id: int ):
	database[ record_id ][ "nodes" ][ node_id ][ "links" ].clear()
	owner.set_filename_label_modified( true )


""" Erasing Nodes """


func make_node_id_available( record_id: int, node_id: int):
	database[ record_id ][ "available_node_ids" ].push_front( node_id )
	database[ record_id ][ "available_node_ids" ].sort()
	owner.set_filename_label_modified( true )


func erase_node( record_id: int, node_id: int):
	database[ record_id ][ "nodes" ].erase( node_id )
	make_node_id_available( record_id, node_id )
	owner.set_filename_label_modified( true )
