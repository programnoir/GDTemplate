@tool
extends EditorPlugin

#	Array containing steps for loading assets into a game.
const AUTOLOAD_ORDER: Array = [
	'GlobalActionIgnoreList',
	'GlobalFontList',
	'GlobalUserSettings',
	'GlobalUIScreenFade'
]

const AUTOLOAD_LIST: Dictionary = {
	'GlobalFontList': 'res://addons/gdtemplate/autoload/global-font-list.gd',
	'GlobalActionIgnoreList': 'res://addons/gdtemplate/autoload/' + 
			'global-action-ignore-list.gd',
	'GlobalUserSettings': 'res://addons/gdtemplate/autoload/' + 
			'global-user-settings.gd',
	'GlobalUIScreenFade': 'res://addons/gdtemplate/ui/' +
			'global-ui-screenfade.tscn'
}


func _get_plugin_name():
	return "GDTemplate"


func _enter_tree():
	for key in AUTOLOAD_ORDER:
		add_autoload_singleton( key, AUTOLOAD_LIST[ key ] )


func _exit_tree():
	for key in AUTOLOAD_LIST.keys():
		remove_autoload_singleton( key )
