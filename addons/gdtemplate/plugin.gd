@tool
extends EditorPlugin

#	Array containing steps for loading assets into a game.
const autoload_order: Array = [
	'UserSettings',
	'ScreenFade'
]

const autoload_list: Dictionary = {
	'UserSettings': 'res://addons/gdtemplate/autoload/user-settings.gd',
	'ScreenFade': "res://addons/gdtemplate/ui/ui-screenfade.tscn"
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
