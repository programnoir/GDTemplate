@tool
extends Node


func _on_option_button_search_by_item_selected( index: int ) -> void:
	owner.nHBCFilters.update_filter()


func _on_line_edit_search_text_changed( new_text: String ) -> void:
	owner.nHBCFilters.update_filter()


func _on_check_box_tag_filter_toggled( button_pressed: bool ) -> void:
	owner.nHBCFilters.update_filter()


func _on_menu_button_filter_tags_index_pressed( tag: int ) -> void:
	get_parent().toggle_filter_tag( tag )


func connect_setup_signals() -> void:
	get_parent().nMenuButtonFilterTags.get_popup().connect( "index_pressed",
			Callable( self, "_on_menu_button_filter_tags_index_pressed" ) )


func disconnect_setup_signals() -> void:
	get_parent().nMenuButtonFilterTags.get_popup().disconnect( "index_pressed",
			Callable( self, "_on_menu_button_filter_tags_index_pressed" ) )
