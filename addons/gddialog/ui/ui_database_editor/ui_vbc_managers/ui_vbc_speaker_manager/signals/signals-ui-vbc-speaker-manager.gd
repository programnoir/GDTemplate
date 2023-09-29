@tool
extends Node


func _on_line_edit_add_speaker_text_submitted( new_text: String ) -> void:
	get_parent().create_speaker_variable( new_text )


func _on_button_add_speaker_pressed() -> void:
	get_parent().create_speaker_variable(
			get_parent().nLineEditAddSpeaker.text )


func _on_speaker_name_modified(
		current_name: String,
		new_name: String,
		row: DialogSpeakerRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_speaker( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_speaker_color_value_modified(
		speaker_name: String,
		new_value: Color
) -> void:
	owner.nDatabase.set_speaker_color_default_value( speaker_name, new_value )


func _on_speaker_destroyed( row: DialogSpeakerRow ) -> void:
	get_parent().delete_speaker_variable( row )


func connect_speaker_signals( row: DialogSpeakerRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_speaker_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_speaker_color_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_speaker_destroyed" ) )


func disconnect_speaker_signals( row: DialogSpeakerRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_speaker_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_speaker_color_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_speaker_destroyed" ) )
