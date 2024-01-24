@tool
extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditAddColor: LineEdit = get_node(
		"HBCColorOptions/LineEditAddColor" )
@onready var nVBCColors: VBoxContainer = get_node( "SCColors/VBCColors" )

var p_UIColorRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/managers/ui_vbc_color_manager"\
		+ "/ui_color_row/ui-color-row.tscn" )


func create_color_variable(
		color_name: String,
		load: bool = false
) -> DialogColorRow:
	if( load == false ):
		if( owner.nDatabase.add_color_variable( color_name ) == false ):
			return
		#	End defensive return: Color exists/invalid
	var new_row: DialogColorRow = p_UIColorRow.instantiate()
	nVBCColors.add_child( new_row )
	new_row.set_name_ui( color_name )
	nSignals.connect_color_signals( new_row )
	nLineEditAddColor.clear()
	owner.set_filename_label_modified( true )
	return new_row


func delete_color_variable( row: DialogColorRow ) -> void:
	nSignals.disconnect_color_signals( row )
	owner.nDatabase.delete_color_variable( row.get_color_name() )
	row.destroy()


func populate_colors_in_manager() -> void:
	for color_row in owner.nDatabase.colors_list.keys():
		var new_row: DialogColorRow = create_color_variable(
				color_row, true )
		new_row.set_value_ui( owner.nDatabase.colors_list[ color_row ] )


func clear_ui() -> void:
	for child in nVBCColors.get_children():
		delete_color_variable( child )
