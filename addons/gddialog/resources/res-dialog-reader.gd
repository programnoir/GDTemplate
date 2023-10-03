extends RefCounted
class_name DialogReader

""" Terminology:
	Record ID: Databases contain records. Each record is a dialog.
	Node ID: Dialog records contain nodes that are connected to each other.
	Slots: Nodes can connect to more than one node. The outputs are slots.
	Links: The destination node ID is the link of a node's slot.
"""

var currently_loaded_file: String = ""
var db: Dictionary = {}
var record_names: Dictionary = {}
var colors: Dictionary = {}
var flags: Dictionary = {}
var floats: Dictionary = {}
var speakers: Dictionary = {}
var string_arrays: Dictionary = {}
var strings: Dictionary = {}


func read( filepath: String ) -> void:
	var file: DialogDatabaseBaked = load( filepath )
	currently_loaded_file = filepath
	db = file.database.duplicate( true )
	record_names = file.record_names.duplicate( true )
	colors = file.colors_list.duplicate( true )
	flags = file.flags_list.duplicate( true )
	floats = file.floats_list.duplicate( true )
	speakers = file.speakers_list.duplicate( true )
	string_arrays = file.string_arrays_list.duplicate( true )
	strings = file.strings_list.duplicate( true )


""" Database error helpers """


## Pauses the game and reports what is wrong while you fix the database issue.
func reader_error( message: String ) -> void:
	assert( false, "Pausing: " + message )
	read( currently_loaded_file )

## If record ID doesn't exist, calls reader_error.
func check_record_id( record_id: int ) -> void:
	while( db.has( record_id ) == false ):
		reader_error( "No record with this ID." )

## If record or node ID doesn't exist, calls reader_error.
func check_node_id( record_id: int, node_id: int ) -> void:
	check_record_id( record_id )
	while( db[ record_id ][ "nodes" ].has( node_id ) == false ):
		reader_error( "Record " + str( record_id ) + " lacks this node ID." )


func check_keyframe_id( record_id: int, node_id: int, keyframe: int ) -> void:
	check_node_id( record_id, node_id )
	while(
		db[ record_id ][ "nodes" ][ node_id ][ "keyframes" ].has(
				node_id ) == false
	):
		reader_error( "Record " + str( record_id ) + " -> Node ID " + \
				str( node_id ) + " lacks keyframe " + str( keyframe ) )


""" Record and node info """


func get_record_id_by_name( name: String ) -> int:
	while( record_names.has( name ) == false ):
		reader_error( "No record with this name." )
	return record_names[ name ]


func get_node_ids( record_id: int ) -> Array:
	check_record_id( record_id )
	return db[ record_id ][ "nodes" ].keys()


func get_node_type( record_id: int, node_id: int ) -> String:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "type" ]


func get_node_slots( record_id: int, node_id: int ) -> Array:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "links" ].keys()


func get_node_link( record_id: int, node_id: int, slot: int ) -> int:
	check_node_id( record_id, node_id )
	while(
		db[ record_id ][ "nodes" ][ node_id ][ "links" ].has( slot ) == false
	):
		reader_error( "Node ID " + str( node_id ) + " slot not found."\
				+ "Did you link this node's slot to another node?" )
	#	End defensive returns.
	return db[ record_id ][ "nodes" ][ node_id ][ "links" ][ slot ]


""" Getting and Setting Values """


func get_color( variable_name: String ) -> Color:
	return colors[ variable_name ]


func get_speaker_color( variable_name: String ) -> Color:
	return speakers[ variable_name ]


func set_flag_value( variable_name: String, new_value: bool ) -> void:
	flags[ variable_name ] = new_value


func get_flag_value( variable_name: String ) -> bool:
	return flags[ variable_name ]


func set_float_value( variable_name: String, new_value: float ) -> void:
	floats[ variable_name ] = new_value


func get_float_value( variable_name: String ) -> float:
	return floats[ variable_name ]


func set_string_value( variable_name: String, new_value: String ) -> void:
	strings[ variable_name ] = new_value


func get_string_value( variable_name: String ) -> String:
	return strings[ variable_name ]


func set_string_array( variable_name: String, new_value: Array ) -> void:
	string_arrays[ variable_name ] = new_value


func get_string_array( variable_name: String ) -> Array:
	return string_arrays[ variable_name ]


""" Node-Specific Properties """


## Only found in Line node.
func get_text( record_id: int, node_id: int ) -> String:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "text" ]

## Found in Line and Advanced nodes.
func get_speaker( record_id: int, node_id: int ) -> String:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "speaker" ]

## Only found in Advanced nodes.
func get_keyframes( record_id: int, node_id: int ) -> Array:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "keyframes" ]

## Only found in Advanced nodes.
func get_responses( record_id: int, node_id: int ) -> Array:
	check_node_id( record_id, node_id )
	if( db[ record_id ][ "nodes" ][ node_id ].has( "responses" ) == false ):
		return []
	return db[ record_id ][ "nodes" ][ node_id ][ "responses" ]

## Only found in Set GUI.
func get_gui_type( record_id: int, node_id: int ) -> bool:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "gui_type" ]

## Only found in Run Script.
func get_script_path( record_id: int, node_id: int ) -> String:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "script_filepath" ]

## Only found in Run Script.
func get_script_name( record_id: int, node_id: int ) -> String:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "script_funcref" ]

## Found in If and Set.
func get_ifset_value_type( record_id: int, node_id: int ) -> String:
	var value_type = get_node_type( record_id, node_id ).to_lower() + \
			"_value_type"
	return db[ record_id ][ "nodes" ][ node_id ][ value_type ]

## Found in If and Set.
func get_ifset_variable_name( record_id: int, node_id: int ) -> String:
	var var_name = get_node_type( record_id, node_id ).to_lower() + "_name"
	return db[ record_id ][ "nodes" ][ node_id ][ var_name ]

## Found in If and Set.
func get_ifset_values( record_id: int, node_id: int ) -> Variant:
	var type: String = get_node_type( record_id, node_id ).to_lower()
	var values: String = type + "_value"
	if( type == "if" ):
		values += "s"
	return db[ record_id ][ "nodes" ][ node_id ][ values ]

## Found only in If.
func get_if_conditions( record_id: int, node_id: int ) -> Array:
	check_node_id( record_id, node_id )
	return db[ record_id ][ "nodes" ][ node_id ][ "if_conditions" ]

## Found only in Advanced.
func get_keyframe_property(
		record_id: int, 
		node_id: int, 
		keyframe_id: int,
		property: String
) -> Variant:
	check_keyframe_id( record_id, node_id, keyframe_id )
	return db[ record_id ][ "nodes" ][ node_id ]\
			[ "keyframes" ][ keyframe_id ][ property ]


""" Common Processes """


## A built-in function to process a set variable node.
func set_variable_common( record_id: int, node_id: int ) -> void:
	var var_name: String = get_ifset_variable_name( record_id, node_id )
	match get_ifset_value_type( record_id, node_id ):
		"Flag":
			set_flag_value( var_name, get_ifset_values( record_id, node_id ) )
		"Float":
			set_float_value( var_name, get_ifset_values( record_id, node_id ) )
		"String":
			set_string_value( var_name, get_ifset_values( record_id, node_id ) )
		"String Array":
			set_string_array( var_name, get_ifset_values( record_id, node_id ) )


func get_if_node_slot_common( record_id, node_id: int ) -> int:
	var var_name: String = get_ifset_variable_name( record_id, node_id )
	var var_type: String = get_ifset_value_type( record_id, node_id )
	var next_slot: int = 0
	match var_type:
		"Flag":
			if( get_flag_value( var_name ) == true ):
				return 0
			return 1
		"String":
			var var_value: String = get_string_value( var_name )
			for value in get_ifset_values( record_id, node_id ):
				if( var_value == value ):
					return next_slot
				next_slot += 1
			#	No matches
			return next_slot
		"String Array":
			var array: Array = get_string_array( var_name )
			if( array == get_ifset_values( record_id, node_id ) ):
				return 0
			return 1
	#	Float
	var var_value: float = get_float_value( var_name )
	var values: Array = get_ifset_values( record_id, node_id )
	var conditions: Array = get_if_conditions( record_id, node_id )
	for value in values:
		print( str( var_name ), " ", str( var_value ), " compared to ", str( value ) )
		match conditions[ next_slot ]:
			"Equal to":
				if( var_value == value ):
					return next_slot
			"Greater Than":
				if( var_value > value ):
					return next_slot
			"Less Than":
				if( var_value < value ):
					return next_slot
		next_slot += 1
	#	No matches
	return next_slot
