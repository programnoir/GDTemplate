@tool
extends Control

signal switch_control

#	Main UI information
@onready var nSignals: Node = get_node( "Signals" )
@onready var nPopupEditDialogNode: Popup = get_node( "PopupEditDialogNode" )
@onready var nHBCMenu: HBoxContainer = get_node( "VBoxContainer/HBCMenu" )
@onready var nLabelRecordID: Label = nHBCMenu.get_node( "LabelRecordID" )
@onready var nMenuButtonAddNode: MenuButton = nHBCMenu.get_node(
		"MenuButtonAddNode" )
#	Selected node information
@onready var nGraphEditDialog: GraphEdit = get_node(
		"VBoxContainer/GraphEditDialog" )
@onready var nLabelSelected: Label = nHBCMenu.get_node( "LabelSelected" )
@onready var nLabelNodeSummary: Label = nHBCMenu.get_node( "LabelNodeSummary" )
@onready var nButtonEditNode: Button = nHBCMenu.get_node( "ButtonEditNode" )

var n_Database: Node
var database_editor: Control = null
var record_id: int = -1
var inactive: bool = true
var selected_node: DialogNode = null

var p_start_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_start_node/ui-start-node.tscn" )
var p_end_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_end_node/ui-end-node.tscn" )
var p_line_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_slot_adjustable_node"\
	+ "/ui_dialog_line_node/ui-dialog-line-node.tscn" )
var p_advanced_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_slot_adjustable_node"\
	+ "/ui_dialog_advanced_node/ui-dialog-advanced-node.tscn" )
var p_set_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_dialog_variable_node/ui_set_node"\
	+ "/ui-dialog-variable-set-node.tscn" )
var p_if_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_dialog_variable_node/ui_if_node"\
	+ "/ui-dialog-variable-if-node.tscn" )
var p_set_gui_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_set_gui_node/ui-set-gui-node.tscn" )
var p_run_script_node: PackedScene = preload( "res://addons/gddialog/ui"\
	+ "/ui_dialog_editor/ui_dialog_node/ui_run_script_node"\
	+ "/ui-run-script-node.tscn" )

var dialog_node_types: Dictionary = {
	"Start": p_start_node,
	"End": p_end_node,
	"Line": p_line_node,
	"Advanced": p_advanced_node,
	"If": p_if_node,
	"Set": p_set_node,
	"Set GUI": p_set_gui_node,
	"Run Script": p_run_script_node
}

#	Check GraphEdit's signals.


""" Functions """


func set_database_editor( editor: Control ) -> void:
	database_editor = editor


func set_database( database_ref: Node ) -> void:
	n_Database = database_ref


func set_record_info( new_record_id: int ) -> void:
	record_id = new_record_id
	nLabelRecordID.text = str( record_id )


func create_new_node( node_type: String ) -> void:
	if( record_id == -1 ):
		return
	#	End defensive return: Somehow we failed to track the record.
	var new_node_id: int = n_Database.nDialogNodes.create_node(
			record_id, node_type )
	var new_node: DialogNode = dialog_node_types[ node_type ].instantiate()
	nGraphEditDialog.add_child( new_node )
	nSignals.connect_all_node_signals( new_node, node_type )
	new_node.set_node_id( new_node_id )
	var start_position: Vector2 = ( nGraphEditDialog.scroll_offset +
		Vector2( 40, 40 ) )
	n_Database.nDialogNodes.set_node_property( record_id, new_node_id,
			"graph_offset", start_position )
	new_node.position_offset = start_position


func connect_all_node_link_ui() -> void:
	var from_node_IDs = n_Database.nDialogNodes.get_record_node_ids(
			record_id )
	for from_node_id in from_node_IDs:
		var slots = n_Database.nDialogNodes.get_node_links(
				record_id, from_node_id )
		for slot in slots:
			var to_node_id: int = n_Database.nDialogNodes.get_node_link(
					record_id, from_node_id, slot )
			#	Temporary measure to make the link node connections.
			var to = "NID " + str( to_node_id )
			var from = "NID " + str( from_node_id )
			nGraphEditDialog.connect_node( from, slot, to, 0 )


func refresh_graphnode_connections() -> void:
	nGraphEditDialog.clear_connections()
	connect_all_node_link_ui()


func populate_graph() -> void:
	inactive = false
	var node_IDs: Array = n_Database.nDialogNodes.get_record_node_ids(
			record_id )
	for node_id in node_IDs:
		var new_node: DialogNode
		var node_type: String = n_Database.nDialogNodes.get_node_property(
				record_id, node_id, "type" )
		new_node = dialog_node_types[ node_type ].instantiate()
		nGraphEditDialog.add_child( new_node )
		new_node.set_node_id( node_id )
		new_node.size = n_Database.nDialogNodes.get_node_property(
				record_id, node_id, "rect_size" )
		new_node.position_offset = n_Database.nDialogNodes.get_node_property(
				record_id, node_id, "graph_offset" )
		new_node.nVBCNodeEditor.custom_minimum_size.y = \
				n_Database.nDialogNodes.get_node_property( record_id, node_id,
						"vbc_size" ).y
		if( new_node is DialogSlotAdjustableNode ):
			var slot_count: int = n_Database.nDialogNodes.get_node_property(
					record_id, node_id, "slot_amount" )
			new_node.set_slot_count_ui( slot_count )
		nSignals.connect_all_node_signals( new_node, node_type )
		#	Adjustments specific to node type. Might convert this code into a
		#	 function that accepts the node data.
		match node_type:
			"Line":
				var new_text = n_Database.nDialogNodes.get_node_property(
						record_id, node_id, "text" )
				new_node.set_text_ui( new_text )
			"Advanced":
				var summary_string = ""
				var node_data = n_Database.nDialogNodes.get_node_data(
						record_id, node_id )
				for keyframe in node_data[ "keyframes" ]:
					summary_string += keyframe[ "text" ]
				if( summary_string.length() > 30 ):
					summary_string = summary_string.substr( 0, 29 )
				new_node.set_summary( summary_string )
			"If":
				new_node.populate_node_data(
						n_Database.nDialogNodes.get_node_data( record_id,
								node_id ) )
			"Set":
				var summary_string: String = \
						n_Database.nDialogNodes.get_node_property( record_id,
						node_id, "set_value_type" )
				summary_string += "\n"
				summary_string += n_Database.nDialogNodes.get_node_property(
						record_id, node_id, "set_name" )
				summary_string += "="
				summary_string += str( n_Database.nDialogNodes\
						.get_node_property( record_id, node_id, "set_value" ) )
				new_node.set_summary( summary_string )
			"Set GUI":
				new_node.set_summary( n_Database.nDialogNodes.get_node_property(
						record_id, node_id, "gui_type" ) )
			"Run Script":
				new_node.set_summary( n_Database.nDialogNodes.get_node_property(
						record_id, node_id, "script_funcref" ) )


func disconnect_node_slot( node_id: int, slot: int ) -> void:
	var to_id: int = n_Database.nDialogNodes.get_node_link(
			record_id, node_id, slot )
	if( to_id == -1 ):
		return
	#	End defensive return
	var from: String = "NID " + str( node_id )
	var to: String = "NID " + str( to_id )
	nGraphEditDialog.disconnect_node( from, slot, to, 0 )


func _ready() -> void:
	nSignals.connect_setup_signals()


#	This clears the editor UI without affecting any database record data.
func clear_editor_ui() -> void:
	inactive = true
	var children: Array = nGraphEditDialog.get_children()
	#nGraphEditDialog.clear_connections()
	#	End defensive return?
	nGraphEditDialog.clear_connections()
	for child in children:
		if( child is DialogNode ):
			#	Must disconnect the signals that we created.
			var type: String = n_Database.nDialogNodes.get_node_property(
					record_id, child.get_node_id(), "type" )
			nSignals.disconnect_all_node_signals( child, type )
			child.destroy()
	record_id = -1


func destroy() -> void:
	clear_editor_ui()
	nPopupEditDialogNode.destroy()
	nSignals.disconnect_setup_signals()
