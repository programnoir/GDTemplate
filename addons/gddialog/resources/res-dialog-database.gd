@tool
extends Resource
class_name DialogDatabase
#	Filetype used in Godot.
@export var TYPE: String = "dialog_database"
#	Properties of the filetype.
@export var database: Dictionary
@export var record_names: Dictionary
@export var flags_list: Dictionary
@export var strings_list: Dictionary
@export var floats_list: Dictionary
@export var string_arrays_list: Dictionary
@export var colors_list: Dictionary
@export var speakers_list: Dictionary
@export var tags_list: Array
@export var available_record_ids: Array
