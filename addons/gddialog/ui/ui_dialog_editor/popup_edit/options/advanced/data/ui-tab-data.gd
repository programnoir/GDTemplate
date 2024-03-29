@tool
extends VBoxContainer

@onready var nVBCBuiltInData: VBoxContainer = get_node(
		"VBoxContainer/SCData/HBCData/VBCBuiltInData" )
@onready var nVBCCustomData: VBoxContainer = get_node(
		"VBoxContainer/SCData/HBCData/VBCCustomData" )
@onready var nOptionButtonType: OptionButton = get_node(
			"VBoxContainer/HBCAddDataOptions/OptionButtonType" )
@onready var nOptionButtonCustomType: OptionButton = get_node(
			"VBoxContainer/HBCAddDataOptions/OptionButtonCustomType" )
@onready var nLineEditCustomString: LineEdit = get_node(
			"VBoxContainer/HBCAddDataOptions/LineEditCustomString" )
@onready var nSpinBoxCustomFloat: SpinBox = get_node(
			"VBoxContainer/HBCAddDataOptions/SpinBoxCustomFloat" )
@onready var nOptionButtonBuiltInType: OptionButton = get_node(
			"VBoxContainer/HBCAddDataOptions/OptionButtonBuiltInType" )
@onready var nOptionButtonVariable: OptionButton = get_node(
			"VBoxContainer/HBCAddDataOptions/OptionButtonVariable" )


var p_custom_data_row: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/popup_edit/options/advanced/data"\
		+ "/ui_custom_data_row/ui-custom-data-row.tscn" )
var p_builtin_variable_row: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/popup_edit/options/advanced/data"
		+ "/ui_builtin_variable_row/ui-builtin-variable-row.tscn" )


func clear_ui() -> void:
	for child in nVBCBuiltInData.get_children():
		child.destroy()
	for child in nVBCCustomData.get_children():
		child.destroy()


func add_data_ui() -> void:
	match nOptionButtonType.selected:
		0:
			var new_custom_row: HBoxContainer = p_custom_data_row.instantiate()
			nVBCCustomData.add_child( new_custom_row )
			match nOptionButtonCustomType.selected:
				0:
					new_custom_row.set_data( nLineEditCustomString.text )
				1:
					new_custom_row.set_data( nSpinBoxCustomFloat.value )
		1:
			if( nOptionButtonVariable.selected == -1 ):
				return
			#	End defensive return: No variable selected.
			var new_builtin_row: HBoxContainer = \
					p_builtin_variable_row.instantiate()
			nVBCBuiltInData.add_child( new_builtin_row )
			var type: String = ""
			match nOptionButtonBuiltInType.selected:
				0:
					type = "Flag"
				1:
					type = "Float"
				2:
					type = "String"
			var variable: String = nOptionButtonVariable.get_item_text(
					nOptionButtonVariable.selected )
			new_builtin_row.set_data( type, variable )


func save_current_keyframe( data: Dictionary ) -> void:
	var builtins: Array = []
	var customs: Array = []
	for child in nVBCBuiltInData.get_children():
		builtins.append( child.get_data().duplicate( true ) )
	for child in nVBCCustomData.get_children():
		customs.append( child.get_data() )
	data[ "custom_data" ] = customs.duplicate( true )
	data[ "variable_data" ] = builtins.duplicate( true )


func load_current_keyframe() -> void:
	clear_ui()
	var builtins: Array = owner.get_keyframe_property( "variable_data" )
	var customs: Array = owner.get_keyframe_property( "custom_data" )
	for builtin in builtins:
		var new_builtin_row: HBoxContainer = \
				p_builtin_variable_row.instantiate()
		nVBCBuiltInData.add_child( new_builtin_row )
		new_builtin_row.set_data( builtin[ "type" ], builtin[ "variable" ] )
	for custom in customs:
		var new_custom_row: HBoxContainer = p_custom_data_row.instantiate()
		nVBCCustomData.add_child( new_custom_row )
		new_custom_row.set_data( custom )


func populate_ui() -> void:
	nOptionButtonVariable.clear()
	var type: int = nOptionButtonBuiltInType.selected
	var array: Array = []
	match type:
		0:
			array = owner.flags_array
		1:
			array = owner.floats_array
		2:
			array = owner.strings_array
	for variable in array:
		nOptionButtonVariable.add_item( variable )
	if( nOptionButtonVariable.item_count > 0 ):
		nOptionButtonVariable.select( 0 )
