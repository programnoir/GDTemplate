@tool
extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditNewFloat: LineEdit = get_node(
		"HBCFloatOptions/LineEditNewFloat" )
@onready var nVBCFloats: VBoxContainer = get_node( "SCFloats/VBCFloats" )

var p_UIFloatRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_vbc_managers/ui_vbc_float_manager"\
		+ "/ui_float_row/ui-float-row.tscn" )


func create_float_variable(
		float_name: String,
		load: bool = false
) -> DialogFloatRow:
	if( load == false ):
		if( owner.nDatabase.add_float_variable( float_name ) == false ):
			return
		#	End defensive return: Float exists/invalid
	var new_row: DialogFloatRow = p_UIFloatRow.instantiate()
	nVBCFloats.add_child( new_row )
	new_row.set_name_ui( float_name )
	nSignals.connect_float_signals( new_row )
	nLineEditNewFloat.clear()
	owner.set_filename_label_modified( true )
	return new_row


func delete_float_variable( row: DialogFloatRow ) -> void:
	nSignals.disconnect_float_signals( row )
	owner.nDatabase.delete_float_variable( row.get_float_name() )
	row.destroy()


func populate_floats_in_manager() -> void:
	for float_row in owner.nDatabase.floats_list.keys():
		var new_row: DialogFloatRow = create_float_variable(
				float_row, true )
		new_row.set_value_ui( owner.nDatabase.floats_list[ float_row ] )


func clear_ui() -> void:
	for child in nVBCFloats.get_children():
		delete_float_variable( child )
