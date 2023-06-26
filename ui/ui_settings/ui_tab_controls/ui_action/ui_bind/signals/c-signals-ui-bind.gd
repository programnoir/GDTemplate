extends Node

func _on_ui_button_remove_bind_pressed() -> void:
	owner.nUIButtonRemoveBind.find_prev_valid_focus().grab_focus()
	owner.destroy()


func _on_ui_button_remove_bind_focus_entered():
	owner.emit_signal( "focus_entered",
			owner.position.y + owner.nUIButtonRemoveBind.size.y / 2  )


func remove_signals() -> void:
	var removed_signals: Array = \
		owner.get_signal_connection_list( "removed_bind" )
	for removed_signal in removed_signals:
		removed_signal[ "signal" ].disconnect( removed_signal[ "callable" ] )
	removed_signals = owner.get_signal_connection_list( "focus_entered" )
	for removed_signal in removed_signals:
		removed_signal[ "signal" ].disconnect( removed_signal[ "callable" ] )


