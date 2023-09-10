@tool
extends Popup

@onready var nSignals: Node = get_node( "Signals" )
@onready var nHBCPopupTitle: HBoxContainer = get_node(
			"Panel/VBoxContainer/HBCPopupTitle" )
@onready var nSCNodeOptions: ScrollContainer = get_node(
			"Panel/VBoxContainer/SCNodeOptions" )
@onready var nHBCPopupSaveQuit: HBoxContainer = get_node(
			"Panel/VBoxContainer/HBCPopupSaveQuit" )


var dialog_node: DialogNode = null
var nVBCNodeOptions: DialogNodeOptions = null

var p_advanced_node: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/ui_popup_edit_dialog_node/ui_dialog_node_options"\
		+ "/ui_dialog_node_options_advanced/ui-dialog-node-options-advanced.tscn" )
var p_if_node: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/ui_popup_edit_dialog_node/ui_dialog_node_options"\
		+ "/ui_dialog_node_options_var/ui_dialog_node_options_if_var"\
		+ "/ui-dialog-node-options-if-var.tscn" )
var p_set_node: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/ui_popup_edit_dialog_node/ui_dialog_node_options"\
		+ "/ui_dialog_node_options_var/ui_dialog_node_options_set_var"\
		+ "/ui-dialog-node-options-set-var.tscn" )
var p_set_gui_options: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/ui_popup_edit_dialog_node/ui_dialog_node_options"\
		+ "/ui_dialog_node_options_set_gui/ui-dialog-node-options-set-gui.tscn")
var p_run_script_options: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/ui_popup_edit_dialog_node/ui_dialog_node_options"\
		+ "/ui_dialog_node_options_run_script"\
		+ "/ui-dialog-node-options-run-script.tscn")
var node_types: Dictionary = {
	#"Line": p_line_node,
	"Advanced": p_advanced_node,
	"If": p_if_node,
	"Set": p_set_node,
	"Set GUI": p_set_gui_options,
	"Run Script": p_run_script_options
}


func prepare_node_options() -> void:
	if( owner.selected_node == null ):
		hide()
		return
	#	End defensive return: No node selected?
	#	I think I should send available info like flags/strings first
	nVBCNodeOptions = node_types[ owner.selected_node.type ].instantiate()
	nSCNodeOptions.add_child( nVBCNodeOptions )
	var passed_node_data: Dictionary = owner.n_Database.nDialogNodes\
			.get_node_data( owner.record_id, owner.selected_node.get_node_id() )
	nVBCNodeOptions.set_node_data( passed_node_data )
	if( nVBCNodeOptions is DialogNodeOptionsVar ):
		nVBCNodeOptions.set_variable_arrays(
				owner.n_Database.flags_list.keys(),
				owner.n_Database.strings_list.keys(),
				owner.n_Database.floats_list.keys(),
				owner.n_Database.string_arrays_list.keys() )
		#	TODO: Pass Conditions to IF node
	match owner.selected_node.type:
		"Advanced":
			nVBCNodeOptions.pass_variable_data(
					owner.n_Database.flags_list.keys(),
					owner.n_Database.floats_list.keys(),
					owner.n_Database.strings_list.keys(),
					owner.n_Database.string_arrays_list.keys(),
					owner.n_Database.speakers_list.keys(),
					owner.n_Database.colors_list )
	#	But for now sending data to the node.
	nVBCNodeOptions.populate_ui()
	


func save_node_data() -> void:
	nVBCNodeOptions.write_node_data()
	var node_data: Dictionary = nVBCNodeOptions.get_node_data()
	owner.n_Database.nDialogNodes.set_node_data( owner.record_id,
			owner.selected_node.get_node_id(), node_data )
	#	Next, take the selected node and modify its summary.
	match owner.selected_node.type:
		"Advanced":
			var summary_string = ""
			if( node_data[ "speaker" ] != "" ):
				summary_string = node_data[ "speaker" ] + "\n"
			for keyframe in node_data[ "keyframes" ]:
				summary_string += keyframe[ "text" ]
			if( summary_string.length() > 30 ):
				summary_string = summary_string.substr( 0, 29 )
			owner.selected_node.set_summary( summary_string )
		"If":
			owner.selected_node.populate_node_data( node_data )
			owner.refresh_graphnode_connections()
		"Set":
			var summary_string: String = node_data[ "set_value_type" ]
			summary_string += "\n"
			summary_string += node_data[ "set_name" ]
			summary_string += "="
			summary_string += str( node_data[ "set_value" ] )
			owner.selected_node.set_summary( summary_string )
		"Set GUI":
			owner.selected_node.set_summary( node_data[ "gui_type" ] )
		"Run Script":
			owner.selected_node.set_summary( node_data[ "script_funcref" ] )
	hide()


func destroy() -> void:
	if( nVBCNodeOptions == null ):
		return
	#	End defensive return
	nVBCNodeOptions.destroy()
