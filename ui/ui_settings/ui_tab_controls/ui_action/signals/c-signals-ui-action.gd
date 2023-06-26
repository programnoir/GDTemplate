extends Node


func _on_ui_button_add_bind_pressed() -> void:
	owner.emit_signal( "adding_bind", owner )


func _on_ui_button_add_bind_focus_entered() -> void:
	owner.emit_signal( "focus_entered",
		owner.position.y + owner.nUIButtonAddBind.size.y / 2 )


func _on_ui_button_bind_focus_entered( this_position_y: int ) -> void:
	var total: int = owner.position.y + this_position_y
	owner.emit_signal( "focus_entered", total )


func remove_signals() -> void:
	var removed_signals: Array = \
		owner.get_signal_connection_list( "adding_bind" )
	for removed_signal in removed_signals:
		removed_signal[ "signal" ].disconnect( removed_signal[ "callable" ] )
	removed_signals = owner.get_signal_connection_list( "focus_entered" )
	for removed_signal in removed_signals:
		removed_signal[ "signal" ].disconnect( removed_signal[ "callable" ] )
