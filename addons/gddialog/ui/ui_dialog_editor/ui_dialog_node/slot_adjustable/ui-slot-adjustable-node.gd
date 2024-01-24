@tool
extends DialogNode
class_name DialogSlotAdjustableNode

signal changed_slot_amount( node_id, new_slot_amount )

@onready var nSpinBoxSlots: SpinBox = get_node( "VBCNodeEditor"\
		+ "/HBCSlots/SpinBoxSlots" )
var slot_count: int = 1


""" Signals """


func _on_ui_dialog_node_close_request() -> void:
	super()


func _on_ui_dialog_node_position_offset_changed() -> void:
	super()


func _on_ui_dialog_node_resize_request( new_minsize: Vector2 ) -> void:
	super( new_minsize )


func _on_spin_box_slots_value_changed( value: int ):
	var old_size: Vector2 = size
	#	Update the slot size.
	slot_count = int( value )
	update_slots()
	emit_signal( "changed_slot_amount", node_id, slot_count )
	#	Resize stuff: If we grew the box...
	size.y = 0
	var new_size_difference: Vector2 = size - old_size
	vbc_size.y += new_size_difference.y
	emit_signal( "changed_size", node_id, size, nVBCNodeEditor.size )


""" Signal Managemnet """


func connect_all_signals() -> void:
	super()
	await( "ready" )
	nSpinBoxSlots.connect( "value_changed", Callable( self,
			"_on_spin_box_slots_value_changed" ) )


func disconnect_all_signals() -> void:
	super()
	nSpinBoxSlots.disconnect( "value_changed", Callable( self,
			"_on_spin_box_slots_value_changed" ) )


""" Slot Amount """


func set_slot_count( new_amount: int ) -> void:
	slot_count = new_amount


func get_slot_count() -> int:
	return slot_count


func set_slot_count_ui( amount: int ) -> void:
	nSpinBoxSlots.value = amount


""" Slot Labels """


func clear_link_labels() -> void:
	var children = get_children()
	for child in children:
		if( child is Label ):
			child.free()


""" Updating Slots """


func update_slots() -> void:
	#	GraphNode function
	clear_all_slots()
	#	Referenced earlier
	clear_link_labels()
	#	Add slots and labels.
	for slot in range( 0, slot_count ):
		set_slot( slot, false, 0, Color( 1.0, 1.0, 1.0, 1.0 ),
				true, 0, Color( 1.0, 1.0, 1.0, 1.0 ) )
		var output_link_label: Label = Label.new()
		add_child( output_link_label )
		move_child( output_link_label, slot )
		output_link_label.text = str( slot )
		output_link_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	set_slot_enabled_left( 0, true )
