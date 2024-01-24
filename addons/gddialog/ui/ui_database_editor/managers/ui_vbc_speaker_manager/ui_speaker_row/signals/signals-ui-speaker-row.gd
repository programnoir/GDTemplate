@tool
extends Node


func _on_line_edit_speaker_name_focus_entered() -> void:
	owner.last_saved_name = owner.nLineEditSpeakerName.text


func _on_line_edit_speaker_name_focus_exited() -> void:
	var new_text = owner.nLineEditSpeakerName.text
	owner.change_name( new_text )


func _on_line_edit_speaker_name_text_submitted( new_text: String ) -> void:
	owner.nLineEditSpeakerName.release_focus()
	

func _on_color_picker_button_color_changed( color: Color ):
	owner.emit_signal( "value_modified", owner.nLineEditSpeakerName.text,
			color )


func _on_button_delete_speaker_pressed() -> void:
	owner.emit_signal( "destroyed", owner )
