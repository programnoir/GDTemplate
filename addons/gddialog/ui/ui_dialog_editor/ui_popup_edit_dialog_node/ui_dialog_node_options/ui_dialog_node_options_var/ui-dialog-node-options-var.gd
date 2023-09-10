@tool
extends DialogNodeOptions
class_name DialogNodeOptionsVar

var flags: Array = []
var strings: Array = []
var floats: Array = []
var string_arrays: Array = []


func get_flags() -> Array:
	return flags


func get_strings() -> Array:
	return strings


func get_floats() -> Array:
	return floats


func get_string_arrays() -> Array:
	return string_arrays


func set_variable_arrays(
		flag_keys: Array,
		string_keys: Array,
		float_keys: Array,
		string_arrays_keys: Array
) -> void:
	flags = flag_keys
	strings = string_keys
	floats = float_keys
	string_arrays = string_arrays_keys


func populate_options_list( options: OptionButton, new_list: Array ) -> void:
	options.clear()
	if( new_list.size() == 0 ):
		return
	#	End defensive return: Empty
	for item in new_list:
		options.add_item( item )
	options.select( 0 )
