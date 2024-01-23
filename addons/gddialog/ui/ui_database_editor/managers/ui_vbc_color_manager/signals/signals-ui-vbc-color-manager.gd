@tool
extends Node


func _on_line_edit_add_color_text_submitted( new_text: String ) -> void:
	get_parent().create_color_variable( new_text )


func _on_button_add_color_pressed() -> void:
	get_parent().create_color_variable( get_parent().nLineEditAddColor.text )


func _on_color_name_modified(
		current_name: String,
		new_name: String,
		row: DialogColorRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_color( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_color_value_modified(
		color_name: String,
		new_value: Color
) -> void:
	owner.nDatabase.set_color_default_value( color_name, new_value )


func _on_color_destroyed( row: DialogColorRow ) -> void:
	get_parent().delete_color_variable( row )


func connect_color_signals( row: DialogColorRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_color_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_color_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_color_destroyed" ) )


func disconnect_color_signals( row: DialogColorRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_color_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_color_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_color_destroyed" ) )
