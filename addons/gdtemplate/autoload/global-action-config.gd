extends Node

const BIND_TRANSLATIONS: String = "data/translations/binds.csv"

#	Here you can specify which built-in controls you wish to hide.
var hide_list: Array = [
"ui_filedialog_show_hidden","ui_text_completion_accept","ui_text_newline_blank",
"ui_text_indent","ui_paste","ui_undo","ui_cut",
"ui_text_add_selection_for_next_occurrence","ui_text_select_word_under_caret",
"ui_text_select_word_under_caret.macos","ui_text_backspace_all_to_left.macos",
"ui_text_clear_carets_and_selection","ui_text_select_all","ui_text_scroll_up",
"ui_text_caret_document_start.macos","ui_graph_duplicate","ui_text_backspace",
"ui_text_caret_line_start","ui_text_caret_word_right","ui_text_newline_above",
"ui_text_completion_query","ui_text_caret_word_left","ui_text_caret_line_end",
"ui_text_caret_page_down","ui_swap_input_direction","ui_text_caret_add_below",
"ui_text_caret_line_start.macos","ui_text_caret_right","ui_text_scroll_down",
"ui_text_caret_word_left.macos","ui_text_caret_add_below.macos","ui_page_up",
"ui_text_caret_line_end.macos","ui_text_backspace_word.macos","ui_page_down",
"ui_text_caret_document_start","ui_text_delete_all_to_right","ui_focus_prev",
"ui_text_caret_add_above","ui_text_scroll_up.macos","ui_text_backspace_word",
"ui_text_delete_all_to_right.macos","ui_text_caret_left","ui_text_caret_up",
"ui_text_caret_add_above.macos","ui_text_backspace_all_to_left",
"ui_text_caret_page_up","ui_filedialog_refresh","ui_focus_next","ui_select",
"ui_filedialog_up_one_level","ui_text_caret_document_end","ui_text_delete",
"ui_text_completion_replace","ui_text_toggle_insert_mode","ui_text_submit",
"ui_text_caret_document_end.macos","ui_text_caret_down","ui_graph_delete",
"ui_text_caret_word_right.macos","ui_text_delete_word","ui_text_newline",
"ui_text_scroll_down.macos","ui_text_delete_word.macos","ui_text_dedent",
"ui_redo","ui_home","ui_copy","ui_menu","ui_end"
]

var bind_name_replaces: Dictionary = {}


"""
A lot borrowed from
https://github.com/godotengine/godot/blob/master/editor/translations/editor/ja.po
"""
func get_replaces() -> Dictionary:
	return bind_name_replaces


func set_new_replaces( column_id: int ) -> void:
	bind_name_replaces.clear()
	if( column_id == 1 ):
		return
	#	End defensive return: English language selected, no replaces needed.
	var file = FileAccess.open( BIND_TRANSLATIONS, FileAccess.READ )
	#	Gets past the header column.
	var row: PackedStringArray = file.get_csv_line()
	while( file.get_position() < file.get_length() ):
		row = file.get_csv_line()
		var from: String = row[ 1 ]
		var to: String = row[ column_id ]
		bind_name_replaces[ from ] = to
	file.close()


func find_replaces( message: String ) -> String:
	if( bind_name_replaces.size() == 0 ):
		return message
	#	End defensive return: English language selected.
	var translated: String = message
	for word in bind_name_replaces.keys():
		translated = translated.replacen( word, bind_name_replaces[ word ] )
	return translated
