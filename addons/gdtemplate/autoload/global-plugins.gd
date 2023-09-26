@tool
extends Node

const CONFIG_DIR: String = "data/resources/"
const CONFIG_FILE_NAME: String = "res-plugins"
const CONFIG_EXTENSION: String = ".tres"
var plugins: Array = []
var plugin_translations: Array = []


func load_plugins() -> void:
	var dirtext: String = "res://"
	if( ResourceLoader.exists( dirtext + CONFIG_DIR + CONFIG_FILE_NAME + \
			CONFIG_EXTENSION ) == false ):
		save_plugins()
	var new_load: Resource = ResourceLoader.load(
			dirtext + CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION,
			'Resource', 1 )
	plugins = new_load.plugins.duplicate( true )
	plugin_translations = new_load.plugin_translations.duplicate( true )


func save_plugins() -> void:
	var new_save: = PluginsList.new()
	#	Adding options to file.
	new_save.plugins = plugins.duplicate( true )
	new_save.plugin_translations = plugin_translations.duplicate( true )
	var dirtext: String = "res://"
	var dir := DirAccess.open( dirtext )
	if( dir.dir_exists( CONFIG_DIR ) == false ):
		dir.make_dir_recursive( CONFIG_DIR )
	ResourceSaver.save( new_save,
			dirtext + CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION )
	var new_load: Resource = ResourceLoader.load(
			dirtext + CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION,
			'Resource', 1 )


func _enter_tree() -> void:
	load_plugins()


func _ready() -> void:
	load_plugins()
	if( Engine.is_editor_hint() == false ):
		for translation in plugin_translations:
			TranslationServer.add_translation( load( translation ) )


func _exit_tree() -> void:
	save_plugins()


"""
	Plugin handling
"""


func add_plugin_to_list( plugin_info: Array ) -> void:
	if( plugins.has( plugin_info ) ):
		return
	#	End defensive return: Avoiding duplicate entry.
	plugins.append( plugin_info )
	save_plugins()


func erase_plugin_from_list( plugin_info: Array ) -> void:
	if( plugins.has( plugin_info ) ):
		plugins.erase( plugin_info )


"""
	Plugin translation handling
"""


func add_translation( filepath: String ) -> void:
	if( plugin_translations.has( filepath ) ):
		return
	#	End defensive return: Avoiding duplicate entry.
	plugin_translations.append( filepath )
	save_plugins()


func remove_translation( filepath: String ) -> void:
	if( plugin_translations.has( filepath ) ):
		plugin_translations.erase( filepath )


func request_plugins() -> Array:
	return plugins
