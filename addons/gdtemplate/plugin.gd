@tool
extends EditorPlugin

#	Array containing steps for loading assets into a game.
const autoload_order: Array = [
	'GlobalActionIgnoreList',
	'GlobalUserSettings',
	'GlobalUIScreenFade'
]

const autoload_list: Dictionary = {
	'GlobalActionIgnoreList': 'res://addons/gdtemplate/autoload/global-action-ignore-list.gd',
	'GlobalUserSettings': 'res://addons/gdtemplate/autoload/global-user-settings.gd',
	'GlobalUIScreenFade': "res://addons/gdtemplate/ui/global-ui-screenfade.tscn"
}

func _get_plugin_name():
	return "GDTemplate"


func _enter_tree():
	for key in autoload_order:
		add_autoload_singleton( key, autoload_list[ key ] )


func _exit_tree():
	var keys: Array = autoload_list.keys()
	for key in keys:
		remove_autoload_singleton( key )
