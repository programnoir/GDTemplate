@tool
extends Resource
class_name DialogDatabaseBaked
#	Filetype used in Godot.
@export var TYPE: String = "baked_dialog_database"
#	Properties of the filetype.
@export var database: Dictionary
@export var record_names: Dictionary
@export var flags_list: Dictionary
@export var strings_list: Dictionary
@export var floats_list: Dictionary
@export var string_arrays_list: Dictionary
@export var colors_list: Dictionary
@export var speakers_list: Dictionary
