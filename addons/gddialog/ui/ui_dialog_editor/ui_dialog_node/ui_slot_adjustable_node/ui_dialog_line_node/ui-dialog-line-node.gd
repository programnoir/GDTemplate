@tool
extends DialogSlotAdjustableNode
class_name DialogLineNode

signal changed_dialog_text( node_id, new_text )

@onready var nTextEditDialog: TextEdit = get_node(
		"VBCNodeEditor/TextEditDialog" )

""" Signals """


func _on_ui_dialog_node_close_request() -> void:
	super()


func _on_ui_dialog_node_position_offset_changed() -> void:
	super()


func _on_ui_dialog_node_resize_request( new_minsize: Vector2 ) -> void:
	super( new_minsize )


func _on_spin_box_slots_value_changed( value: int ):
	super( value )


func _on_text_edit_focus_exited() -> void:
	emit_signal( "changed_dialog_text", node_id, nTextEditDialog.text )


func set_text_ui( new_text: String ) -> void:
	nTextEditDialog.text = new_text
