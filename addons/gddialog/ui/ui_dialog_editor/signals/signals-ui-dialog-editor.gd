@tool
extends Node


func _on_button_back_pressed() -> void:
	owner.clear_editor_ui()
	owner.emit_signal( "switch_control" )


func _on_button_edit_node_pressed() -> void:
	if( owner.selected_node == null ):
		return
	#	End defensive return: No node selected.
	owner.nPopupEditDialogNode.popup_centered()


func _on_menu_button_add_node_id_pressed( id: int ) -> void:
	var type: String = ""
	match id:
		0:
			type = "Line"
		1:
			type = "Advanced"
		2:
			type = "If"
		3:
			type = "Set"
		4:
			type = "Set GUI"
		5:
			type = "Run Script"
		8:
			type = "End"
	owner.create_new_node( type )


""" GraphEdit Signals """


func _on_graph_edit_dialog_node_selected( node: DialogNode ) -> void:
	var type = node.get_type()
	if( type == "Start" or type == "End" or type == "Line" ):
		return
	#	End defensive return: No node selected.
	owner.nButtonEditNode.disabled = false
	owner.nLabelNodeSummary.modulate.a = 1.0
	owner.nLabelSelected.modulate.a = 1.0
	var summary_text = node.get_summary()
	summary_text = summary_text.replacen( "\n", "|" )
	owner.nLabelNodeSummary.text = summary_text
	owner.selected_node = node


func _on_graph_edit_dialog_node_deselected( node: DialogNode ) -> void:
	owner.nButtonEditNode.disabled = true
	owner.nLabelNodeSummary.modulate.a = 100.0/255.0
	owner.nLabelSelected.modulate.a = 100.0/255.0
	owner.selected_node = null


func _on_graph_edit_dialog_connection_request(
	from: String,
	from_slot: int,
	to: String,
	to_slot: int
) -> void:
	if( owner.inactive == true ):
		return
	#	End defensive return: Not exiting
	owner.nGraphEditDialog.connect_node( from, from_slot, to, to_slot )
	var from_node_id = owner.nGraphEditDialog.get_node( from ).get_node_id()
	var to_node_id = owner.nGraphEditDialog.get_node( to ).get_node_id()
	owner.n_Database.nDialogNodes.set_node_link( owner.record_id, from_node_id,
			from_slot, to_node_id )


func _on_graph_edit_dialog_disconnection_request(
	from: String,
	from_slot: int,
	to: String,
	to_slot: int
) -> void:
	if( owner.inactive == true ):
		return
	#	End defensive return: Not exiting
	owner.nGraphEditDialog.disconnect_node( from, from_slot, to, to_slot )
	var from_node_id = owner.nGraphEditDialog.get_node( from ).get_node_id()
	owner.n_Database.nDialogNodes.erase_link_in_node( owner.record_id,
			from_node_id, from_slot )


func _on_node_erased( deleted_node: DialogNode ):
	var deleted_node_id: int = deleted_node.get_node_id()
	owner.n_Database.nDialogNodes.erase_all_links_to_node( owner.record_id,
			deleted_node_id )
	owner.n_Database.nDialogNodes.erase_node( owner.record_id,
			deleted_node_id )
	disconnect_all_ui_links_to( deleted_node )
	deleted_node.destroy()


func _on_node_changed_size(
		node_id: int,
		new_size: Vector2,
		new_vbc_size: Vector2
) -> void:
	owner.n_Database.nDialogNodes.set_node_property(
			owner.record_id, node_id, "rect_size", new_size )
	owner.n_Database.nDialogNodes.set_node_property(
			owner.record_id, node_id, "vbc_size", new_vbc_size )


func _on_node_changed_offset( node_id: int, new_offset: Vector2 ) -> void:
	owner.n_Database.nDialogNodes.set_node_property(
			owner.record_id, node_id, "graph_offset", new_offset )


func _on_node_changed_slot_amount( node_id: int, new_slot_amount: int ) -> void:
	var current_amount: int = owner.n_Database.nDialogNodes.get_node_property(
			owner.record_id, node_id, "slot_amount" )
	if( new_slot_amount < current_amount ):
		var erased_slots: int = current_amount - new_slot_amount
		for i in range( erased_slots ):
			var slot: int = ( current_amount - 1 ) - i
			owner.disconnect_node_slot( node_id, slot )
			owner.n_Database.nDialogNodes.erase_link_in_node( owner.record_id,
					node_id, slot )
	owner.n_Database.nDialogNodes.set_node_property( owner.record_id, node_id,
			"slot_amount", new_slot_amount )


""" Line Node Only """


func _on_node_changed_dialog_text( node_id: int, new_text: String ) -> void:
	owner.n_Database.nDialogNodes.set_node_property( owner.record_id, node_id,
			"text", new_text )


func _on_node_changed_speaker( node_id: int, new_speaker: String ) -> void:
	owner.n_Database.nDialogNodes.set_node_property( owner.record_id, node_id,
			"speaker", new_speaker )


""" Signal Management """


func connect_all_node_signals( node: GraphNode, type: String ) -> void:
	#	Connect the signals that Dialog nodes share.
	node.connect( "erased", Callable( self, "_on_node_erased" ) )
	node.connect( "changed_size", Callable( self, "_on_node_changed_size" ) )
	node.connect( "changed_offset", Callable( self,
			"_on_node_changed_offset" ) )
	#	Inheritance nodes:
	if( node is DialogSlotAdjustableNode ):
		node.connect( "changed_slot_amount", Callable( self,
				"_on_node_changed_slot_amount" ) )
	match type:
		"Line":
			node.connect( "changed_dialog_text", Callable( self,
					"_on_node_changed_dialog_text" ) )
			node.connect( "changed_speaker", Callable( self,
					"_on_node_changed_speaker" ) )


""" Disconnecting Nodes (GUI) """


func disconnect_all_node_signals( node: GraphNode, type: String ) -> void:
	node.disconnect( "erased", Callable( self, "_on_node_erased" ) )
	node.disconnect( "changed_size", Callable( self, "_on_node_changed_size" ) )
	node.disconnect( "changed_offset", Callable( self,
			"_on_node_changed_offset" ) )
	#	Inheritance nodes:
	if( node is DialogSlotAdjustableNode ):
		node.disconnect( "changed_slot_amount", Callable( self,
				"_on_node_changed_slot_amount" ) )
	match type:
		"Line":
			node.disconnect( "changed_speaker", Callable( self,
					"_on_node_changed_speaker" ) )
			node.disconnect( "changed_dialog_text", Callable( self,
					"_on_node_changed_dialog_text" ) )


func disconnect_node_slot( node_id: int, slot: int ) -> void:
	var to_id: int = owner.n_Database.nDialogNodes.get_node_link(
			owner.record_id, node_id, slot )
	if( to_id == -1 ):
		return
	#	End defensive return
	var from: String = "NID " + str( node_id )
	var to: String = "NID " + str( to_id )
	owner.nGraphEditDialog.disconnect_node( from, slot, to, 0 )


func disconnect_all_ui_links_to( node ):
	var node_name = node.name
	var connection_list = owner.nGraphEditDialog.get_connection_list()
	for connection in connection_list:
		if connection[ "from" ] == node.name or connection[ "to" ] == node.name:
			owner.nGraphEditDialog.disconnect_node( connection[ "from" ],
					connection[ "from_port" ], connection[ "to" ],
					connection[ "to_port" ] )


func connect_setup_signals() -> void:
	owner.nMenuButtonAddNode.get_popup().connect( "id_pressed", Callable(
			self, "_on_menu_button_add_node_id_pressed" ) )


func disconnect_setup_signals() -> void:
	owner.nMenuButtonAddNode.get_popup().disconnect( "id_pressed",
			Callable( self, "_on_menu_button_add_node_id_pressed" ) )
