@tool
extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditNewString: LineEdit = get_node(
		"HBCStringOptions/LineEditNewString" )
@onready var nVBCStrings: VBoxContainer = get_node( "SCStrings/VBCStrings" )

var p_UIStringRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_vbc_managers/ui_vbc_string_manager"\
		+ "/ui_string_row/ui-string-row.tscn" )


func create_string_variable(
		string_name: String,
		load: bool = false
) -> DialogStringRow:
	if( load == false ):
		if( owner.nDatabase.add_string_variable( string_name ) == false ):
			return
		#	End defensive return: String exists/invalid name
	var new_row: DialogStringRow = p_UIStringRow.instantiate()
	nVBCStrings.add_child( new_row )
	new_row.set_name_ui( string_name )
	nSignals.connect_string_signals( new_row )
	nLineEditNewString.clear()
	owner.set_filename_label_modified( true )
	return new_row


func delete_string_variable( row: DialogStringRow ) -> void:
	nSignals.disconnect_string_signals( row )
	owner.nDatabase.delete_string_variable( row.get_string_name() )
	row.destroy()


func populate_strings_in_manager() -> void:
	for string_row in owner.nDatabase.strings_list.keys():
		var new_row: DialogStringRow = create_string_variable(
				string_row, true )
		new_row.set_value_ui( owner.nDatabase.strings_list[ string_row ] )


func clear_ui() -> void:
	for child in nVBCStrings.get_children():
		delete_string_variable( child )
