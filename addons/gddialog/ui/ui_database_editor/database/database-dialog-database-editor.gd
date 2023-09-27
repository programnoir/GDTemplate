@tool
extends Node

@onready var nDialogNodes: Node = get_node( "DialogNodes" )

var database: Dictionary = {}
var record_names: Dictionary
var tags_list: Array = []
var flags_list: Dictionary = {}
var strings_list: Dictionary = {}
var floats_list: Dictionary = {}
var string_arrays_list: Dictionary = {}
var colors_list: Dictionary = {}
var speakers_list: Dictionary = {}
#	A list of record ID #s made available when their matching records are
#	 deleted from the database, thus keeping the # of IDs = to _database size.
var available_record_ids : Array = []


func generate_record_id() -> int:
	if( available_record_ids.size() > 0 ):
		return available_record_ids.pop_front()
	return database.size()


func create_dialog_record() -> int:
	var new_record_id: int = generate_record_id()
	var new_record_data: Dictionary = {
		"description": "Description of new dialog",
		"tags": [],
		"nodes": {},
		"available_node_ids": []
	}
	database[ new_record_id ] = new_record_data
	nDialogNodes.create_node( new_record_id, "Start" )
	var end_node_id: int = nDialogNodes.create_node( new_record_id, "End" )
	nDialogNodes.set_node_property( new_record_id, end_node_id, "graph_offset",
			Vector2( 600, 80 ) )
	owner.set_filename_label_modified()
	return new_record_id


""" Flag Operations """


func add_flag_to_flags_list( new_flag: String ) -> void:
	flags_list[ new_flag ] = false


func remove_flag_from_flags_list( flag_name: String ) -> void:
	flags_list.erase( flag_name )
	nDialogNodes.modify_variable_in_nodes( "Flag", flag_name )


""" String Array Operations """


func add_array_to_arrays_list( new_array: String ) -> void:
	string_arrays_list[ new_array ] = false


func remove_array_from_arrays_list( array_name: String ) -> void:
	string_arrays_list.erase( array_name )
	nDialogNodes.modify_variable_in_nodes( "String Array", array_name )


""" String Operations """


func add_string_variable( new_string: String ) -> bool:
	if( strings_list.has( new_string ) ):
		return false
	#	End defensive return: String var exists
	strings_list[ new_string ] = ""
	return true


func rename_string(
		current_name: String,
		new_name: String,
		row: DialogStringRow
) -> bool:
	if( strings_list.has( new_name ) ):
		row.reset_name_ui()
		return false
	#	End defensive return: String name already exists.
	strings_list[ new_name ] = strings_list[ current_name ]
	strings_list.erase( current_name )
	nDialogNodes.modify_variable_in_nodes( "String", current_name, new_name )
	return true


func set_string_default_value(
		string_name: String,
		new_value: String
) -> void:
	if( strings_list.has( string_name ) == false ):
		return
	#	End defensive return: Not found
	strings_list[ string_name ] = new_value


func delete_string_variable( string_name: String ) -> void:
	if( strings_list.has( string_name ) == false ):
		return
	#	End defensive return: Not found
	strings_list.erase( string_name )
	nDialogNodes.modify_variable_in_nodes( "String", string_name )



""" Float Operations """


func add_float_variable( new_float: String ) -> bool:
	if( floats_list.has( new_float ) ):
		return false
	#	End defensive return: String var exists
	floats_list[ new_float ] = 0.0
	return true


func rename_float(
		current_name: String,
		new_name: String,
		row: DialogFloatRow
) -> bool:
	if( floats_list.has( new_name ) ):
		row.reset_name_ui()
		return false
	#	End defensive return: String name already exists.
	floats_list[ new_name ] = floats_list[ current_name ]
	floats_list.erase( current_name )
	nDialogNodes.modify_variable_in_nodes( "Float", current_name, new_name )
	return true


func set_float_default_value(
		float_name: String,
		new_value: float
) -> void:
	if( floats_list.has( float_name ) == false ):
		return
	#	End defensive return: Not found
	floats_list[ float_name ] = new_value


func delete_float_variable( float_name: String ) -> void:
	if( floats_list.has( float_name ) == false ):
		return
	#	End defensive return: Not found
	floats_list.erase( float_name )
	nDialogNodes.modify_variable_in_nodes( "Float", float_name )


""" Color Operations """


func add_color_variable( new_color: String ) -> bool:
	if( colors_list.has( new_color ) ):
		return false
	#	End defensive return: String var exists
	colors_list[ new_color ] = Color( 1.0, 1.0, 1.0, 1.0 )
	return true


func rename_color(
		current_name: String,
		new_name: String,
		row: DialogColorRow
) -> bool:
	if( colors_list.has( new_name ) ):
		row.reset_name_ui()
		return false
	#	End defensive return: String name already exists.
	colors_list[ new_name ] = colors_list[ current_name ]
	colors_list.erase( current_name )
	nDialogNodes.modify_variable_in_nodes( "Color", current_name, new_name )
	return true


func set_color_default_value(
		color_name: String,
		new_value: Color
) -> void:
	if( colors_list.has( color_name ) == false ):
		return
	#	End defensive return: Not found
	colors_list[ color_name ] = new_value


func delete_color_variable( color_name: String ) -> void:
	if( colors_list.has( color_name ) == false ):
		return
	#	End defensive return: Not found
	colors_list.erase( color_name )
	nDialogNodes.modify_variable_in_nodes( "Color", color_name )


""" Speaker Operations """


func add_speaker_variable( new_speaker: String ) -> bool:
	if( speakers_list.has( new_speaker ) ):
		return false
	#	End defensive return: String var exists
	speakers_list[ new_speaker ] = Color( 1.0, 1.0, 1.0, 1.0 )
	return true


func rename_speaker(
		current_name: String,
		new_name: String,
		row: DialogSpeakerRow
) -> bool:
	if( speakers_list.has( new_name ) ):
		row.reset_name_ui()
		return false
	#	End defensive return: String name already exists.
	speakers_list[ new_name ] = speakers_list[ current_name ]
	speakers_list.erase( current_name )
	nDialogNodes.modify_variable_in_nodes( "Speaker", current_name, new_name )
	return true


func set_speaker_color_default_value(
		speaker_name: String,
		new_value: Color
) -> void:
	if( speakers_list.has( speaker_name ) == false ):
		return
	#	End defensive return: Not found
	speakers_list[ speaker_name ] = new_value


func delete_speaker_variable( speaker_name: String ) -> void:
	if( speakers_list.has( speaker_name ) == false ):
		return
	#	End defensive return: Not found
	speakers_list.erase( speaker_name )
	nDialogNodes.modify_variable_in_nodes( "Speaker", speaker_name )


""" Tag Operations """


func get_record_tags( record_id: int ) -> Array:
	return database[ record_id ][ "tags" ]


func add_tag_to_tags_list( new_tag: String ) -> void:
	#	Adding the new tag to the tag list.
	tags_list.push_front( new_tag )
	tags_list.sort()
	owner.set_filename_label_modified()


#	Returns whether or not the tag addition was a success.
func add_tag_to_record( record_id: int, tag_name: String ) -> bool:
	if( database[ record_id ][ "tags" ].has( tag_name ) == true ):
		return false
	#	End defensive return.
	database[ record_id ][ "tags" ].push_front( tag_name )
	database[ record_id ][ "tags" ].sort()
	owner.set_filename_label_modified()
	return true


#	Returns whether or not the tag removal was a success.
func remove_tag_from_record( record_id: int, tag_name: String ) -> bool:
	if( database[ record_id ][ "tags" ].has( tag_name ) == false ):
		return false
	database[ record_id ][ "tags" ].erase( tag_name )
	owner.set_filename_label_modified()
	return true


func remove_tag_from_tags_list( tag_name: String ) -> void:
	tags_list.erase( tag_name )
	owner.set_filename_label_modified()


""" Record Name Field """


func set_record_name( id: int, old_name: String, new_name: String ) -> void:
	if( new_name.length() == 0 or new_name == owner.DEFAULT_RECORD_NAME ):
		if( owner.current_modified_record == null ):
			print( "Somehow, the tool failed to keep track of the row UI." )
			return
		#	End defensive return
		if( record_names.has( old_name ) ):
			record_names.erase( old_name )
		if( database[ id ].has( "name" ) ):
			database[ id ].erase( "name" )
		return
	#	End defensive return
	if( record_names.has( new_name ) ):
		var next_number: int = 1
		var appended_name: String = new_name + "-" + str( next_number )
		while ( record_names.has( appended_name ) == false ):
			next_number += 1
			appended_name = new_name + "-" + str( next_number )
		owner.current_modified_record.set_record_name_field( appended_name )
	record_names[ new_name ] = id
	database[ id ][ "name" ] = new_name
	owner.current_modified_record = null
	owner.set_filename_label_modified()


""" Record Description Field """


func set_record_description( id: int, new_text: String ) -> void:
	database[ id ][ "description" ] = new_text
	owner.set_filename_label_modified()


func get_record_description( id: int ) -> String:
	return database[ id ][ "description" ]


""" Record Deletion """


func delete_dialog_record( record: DialogRecordRow ) -> void:
	var record_id: int = record.get_record_id()
	available_record_ids.push_front( record_id )
	available_record_ids.sort()

	if( database[ record_id ].has( "name" ) ):
		if( record_names.has( database[ record_id ][ "name" ] ) ):
			record_names.erase( database[ record_id ][ "name" ] )
	database.erase( record_id )


""" Wiping the Working Database """


func clear_database() -> void:
	database.clear()
	available_record_ids.clear()
	record_names.clear()
	tags_list.clear()
	strings_list.clear()
	flags_list.clear()
