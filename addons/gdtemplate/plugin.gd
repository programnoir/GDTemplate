@tool
extends EditorPlugin

#	Array containing steps for loading assets into a game.
const AUTOLOAD_ORDER: Array = [
	'GlobalActionConfig',
	'GlobalTheme',
	'GlobalUserSettings',
	'GlobalUIScreenFade',
	'GlobalPlugins'
]

const AUTOLOAD_LIST: Dictionary = {
	'GlobalTheme': 'res://addons/gdtemplate/autoload/global-theme.gd',
	'GlobalActionConfig': 'res://addons/gdtemplate/autoload/' + 
			'global-action-config.gd',
	'GlobalUserSettings': 'res://addons/gdtemplate/autoload/' + 
			'global-user-settings.gd',
	'GlobalUIScreenFade': 'res://addons/gdtemplate/ui/' +
			'global-ui-screenfade.tscn',
	'GlobalPlugins': "res://addons/gdtemplate/autoload/global-plugins.gd"
}


func _get_plugin_name():
	return "GDTemplate"


func _enter_tree():
	for key in AUTOLOAD_ORDER:
		add_autoload_singleton( key, AUTOLOAD_LIST[ key ] )


func _exit_tree():
	for key in AUTOLOAD_LIST.keys():
		remove_autoload_singleton( key )
