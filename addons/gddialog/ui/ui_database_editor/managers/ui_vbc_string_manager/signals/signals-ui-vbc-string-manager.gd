@tool
extends Node


func _on_line_edit_new_string_text_submitted( new_text: String ) -> void:
	get_parent().create_string_variable( new_text )


func _on_button_add_string_pressed() -> void:
	get_parent().create_string_variable( get_parent().nLineEditNewString.text )


func _on_string_name_modified(
		current_name: String,
		new_name: String,
		row: DialogStringRow
) -> void:
	var renamed: bool = owner.nDatabase.rename_string( current_name,
			new_name, row ) 
	if( renamed == true ):
		row.set_last_saved_name( new_name )


func _on_string_value_modified(
		string_name: String,
		new_value: String
) -> void:
	owner.nDatabase.set_string_default_value( string_name, new_value )


func _on_string_destroyed( row: DialogStringRow ) -> void:
	get_parent().delete_string_variable( row )


func connect_string_signals( row: DialogStringRow ) -> void:
	row.connect( "name_modified", Callable( self,
			"_on_string_name_modified" ) )
	row.connect( "value_modified", Callable( self,
			"_on_string_value_modified" ) )
	row.connect( "destroyed", Callable( self, "_on_string_destroyed" ) )


func disconnect_string_signals( row: DialogStringRow ) -> void:
	row.disconnect( "name_modified", Callable( self,
			"_on_string_name_modified" ) )
	row.disconnect( "value_modified", Callable( self,
			"_on_string_value_modified" ) )
	row.disconnect( "destroyed", Callable( self, "_on_string_destroyed" ) )
