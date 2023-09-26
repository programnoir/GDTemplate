extends Node


func _on_adding_bind( action: UIAction ) -> void:
	owner.nTabControls.read_new_bind_input( action )


func _on_removed_bind( action_name: String, bind: InputEvent ) -> void:
	owner.nTabControls.remove_bind_from_action( action_name, bind )


func _on_action_bind_focus_entered( vertical_position: int ) -> void:
	owner.nTabControls.scroll_to_focused_node( vertical_position )


func _on_button_close_settings_pressed() -> void:
	owner.emit_signal( "menu_settings_closed" )


func _on_new_fontlist() -> void:
	owner.nTabAccessibility.populate_font_list()
	owner.nTabAccessibility.set_font(
			owner.nTabAccessibility.DEFAULT_FONT_INDEX )


func _on_buttontab_clicked( button: ButtonTab ) -> void:
	var mid_point: int = ( owner.nSCTabsWrap.size.x / 2.0 ) as int
	var button_x: int = button.get_position().x + ( button.size.x / 2 as int )
	owner.nSCTabsWrap.scroll_horizontal = button_x - mid_point


func connect_signals() -> void:
	GlobalTheme.new_fontlist.connect(
			Callable( self, "_on_new_fontlist" ) )
	owner.nTabAccessibility.nSpinBoxLineEditFontSize.focus_entered.connect(
		Callable( owner.nTabAccessibility.nSignals,
		"_on_spin_box_font_size_focus_entered" ) )


func disconnect_signals() -> void:
	GlobalTheme.new_fontlist.disconnect(
			Callable( self, "_on_new_fontlist" ) )
	owner.nTabAccessibility.nSpinBoxLineEditFontSize.focus_entered.disconnect(
		Callable( owner.nTabAccessibility.nSignals,
		"_on_spin_box_font_size_focus_entered" ) )
