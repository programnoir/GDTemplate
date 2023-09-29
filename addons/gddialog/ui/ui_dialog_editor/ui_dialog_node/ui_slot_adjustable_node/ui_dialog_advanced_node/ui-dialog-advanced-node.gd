@tool
extends DialogSlotAdjustableNode
class_name DialogAdvancedNode


""" Signals """


func _on_ui_dialog_node_close_request() -> void:
	super()


func _on_ui_dialog_node_position_offset_changed() -> void:
	super()


func _on_ui_dialog_node_resize_request( new_minsize: Vector2 ) -> void:
	super( new_minsize )


func _on_spin_box_slots_value_changed( value: int ):
	super( value )
