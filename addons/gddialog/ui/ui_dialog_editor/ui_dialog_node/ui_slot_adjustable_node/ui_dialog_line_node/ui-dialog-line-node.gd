@tool
extends DialogSlotAdjustableNode
class_name DialogLineNode

signal changed_speaker( node_id, new_speaker )
signal changed_dialog_text( node_id, new_text )

@onready var nTextEditDialog: TextEdit = get_node(
		"VBCNodeEditor/TextEditDialog" )
@onready var nOptionButtonSpeaker: OptionButton = get_node(
		"VBCNodeEditor/OptionButtonSpeaker" )

""" Signals """


func _on_ui_dialog_node_close_request() -> void:
	super()


func _on_ui_dialog_node_position_offset_changed() -> void:
	super()


func _on_ui_dialog_node_resize_request( new_minsize: Vector2 ) -> void:
	super( new_minsize )


func _on_spin_box_slots_value_changed( value: int ) -> void:
	super( value )


func _on_text_edit_focus_exited() -> void:
	emit_signal( "changed_dialog_text", node_id, nTextEditDialog.text )


func _on_option_button_speaker_item_selected( index: int ) -> void:
	emit_signal( "changed_speaker", node_id,
			nOptionButtonSpeaker.get_item_text( index ) )


func set_text_ui( new_text: String ) -> void:
	nTextEditDialog.text = new_text


func set_speaker_ui( speakers: Array, speaker_name: String ) -> void:
	var speaker_index: int = 0
	for speaker in speakers:
		nOptionButtonSpeaker.add_item( speaker )
		if( speaker == speaker_name ):
			nOptionButtonSpeaker.select( speaker_index )
		speaker_index += 1
