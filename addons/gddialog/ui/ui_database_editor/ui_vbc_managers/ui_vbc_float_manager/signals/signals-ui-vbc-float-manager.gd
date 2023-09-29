@tool
extends Node


func _on_button_add_float_pressed() -> void:
	var float_name: String = ( get_parent().nLineEditFloatName.text )
	get_parent().create_float_variable( float_name )


func _on_line_edit_new_float_text_submitted( new_text: String ) -> void:
	get_parent().create_float_variable( new_text )


func _on_float_name_modified(
		current_name: String,
		new_name: String,
		row: DialogFloatRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_float( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_float_value_modified(
		string_name: String,
		new_value: float
) -> void:
	owner.nDatabase.set_float_default_value( string_name, new_value )


func _on_float_destroyed( row: DialogFloatRow ) -> void:
	get_parent().delete_float_variable( row )


func connect_float_signals( row: DialogFloatRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_float_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_float_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_float_destroyed" ) )


func disconnect_float_signals( row: DialogFloatRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_float_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_float_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_float_destroyed" ) )
