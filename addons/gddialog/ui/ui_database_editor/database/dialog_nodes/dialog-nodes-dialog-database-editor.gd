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
	#	Begin specific type data modifications.
	match( type ):
		"Line":
			node_data[ "text" ] = ""
		"Advanced":
			node_data[ "speaker" ] = ""
			node_data[ "keyframes" ] = []
		"Set":
			node_data[ "set_name" ] = "Not Set"
			node_data[ "set_value_type" ] = "Flag"
			node_data[ "set_value" ] = false
		"If":
			#	Slot amount keeps track of conditions, in ifs.
			#	Name of the variable being checked
			node_data[ "if_name" ] = "Not Set"
			#	Types: Flag, String, Number
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
	#	End specific type data modifications.
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


#	This one is Variant due to the different types of data possible.
func get_node_property( record_id: int, node_id: int, property: String ):
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


""" Node Flag Information """


func track_node_keyframe_flag_data(
	record_id: int,
	node_id: int,
	slot: int,
	data
) -> void:
	#	First, let's locate the keyframe in our records.
	if( n_Database.keyframe_flag_list.has( record_id ) == false ):
		if( data[ "text_type" ] != 2 ):
			return
		#	It's not in the database and this isn't interactive text. Ignore
		n_Database.keyframe_flag_list[ record_id ] = { node_id: [] }
		n_Database.keyframe_flag_list[ record_id ][ node_id ].push_back( slot )
		return
	#	Check if it's in our record id
	if( n_Database.keyframe_flag_list[ record_id ].has( node_id ) == false ):
		if( data[ "text_type" ] != 2 ):
			return
		n_Database.keyframe_flag_list[ record_id ] = { node_id: [] }
		n_Database.keyframe_flag_list[ record_id ][ node_id ].push_back( slot )
	#	Check if it's in our record -> node
	if( n_Database.keyframe_flag_list[ record_id ][ node_id ]\
			.has( slot ) == false
	):
		if( data[ "text_type" ] != 2 ):
			return
		n_Database.keyframe_flag_list[ record_id ] = { node_id: [] }
		n_Database.keyframe_flag_list[ record_id ][ node_id ].push_back( slot )
	#	Okay, it's there, but it's no longer an interactive text type.
	if( data[ "text_type" ] != 2 ):
		n_Database.keyframe_flag_list[ record_id ][ node_id ].erase( slot )
	#	Otherwise, make no changes.


""" Node Links """


#	Here because we can't use setget_node_property() to handle this.
func set_node_link(
	record_id: int,
	from_id: int,
	from_slot: int,
	to_id: int
) -> void:
	#	Assign the destination ID to the ID of the next connection.
	database[ record_id ][ "nodes" ][ from_id ][ "links" ]\
			[ from_slot ] = to_id
	owner.set_filename_label_modified( true )


func get_node_link( record_id: int, node_id: int, slot: int ) -> int:
	if( database[ record_id ][ "nodes" ][ node_id ]\
			[ "links" ].has( slot ) == false ):
		return -1
	#	End defensive return
	return database[ record_id ][ "nodes" ][ node_id ][ "links" ][ slot ]


""" Resetting Properties """


func replace_variable( type: String, current: String, new: String ) -> void:
	for record_id in range( 0, database.size() ):
		for node_id in range( 1,
			database[ record_id ][ "nodes" ].size()
		):
			var node: Dictionary
			node = database[ record_id ][ "nodes" ][ node_id ]
			var check_text = node[ "type" ].to_lower()
			if( check_text != "if" and check_text != "set"  ):
				continue
			#	End defensive continue: Wrong node type
			if( node[ check_text + "_value_type" ] ) != type:
				continue
			#	End defensive type: Wrong flag type
			if( node[ check_text + "_name" ] == current ):
				node[ check_text + "_name" ] = new


func reset_flag_in_all_nodes( flag: String ) -> void:
	for record_id in range( 0, database.size() ):
		for node_id in range( 1,
			database[ record_id ][ "nodes" ].size()
		):
			var node: Dictionary
			node = database[ record_id ][ "nodes" ][ node_id ]
			if( node[ "type" ] == "If" ):
				if( node[ "flag" ] == flag ):
					node[ "flag" ] = "No Flag"
	#	Advanced nodes contain keyframes that contain flags. We search these.
	for record_id in n_Database.keyframe_flag_list:
		for node_id in n_Database.keyframe_flag_list[ record_id ]:
			for slot in n_Database.keyframe_flag_list[ record_id ][ node_id ]:
				var node: Dictionary
				node = database[ record_id ][ "nodes" ][ node_id ]\
						[ "keyframes" ][ slot ]
				if( node[ "data_flag" ] == flag ):
					node[ "data_flag" ] = "No Flag"


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


#	Nuke the links of this record's node!
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
