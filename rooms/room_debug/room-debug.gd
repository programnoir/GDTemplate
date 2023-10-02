extends Control

@onready var nPlugins: Node = get_node( "Plugins" )


func process_plugins() -> void:
	var plugins: Array = GlobalPlugins.request_plugins()
	for plugin in plugins:
		if( plugin[ 0 ] == "debug" ):
			print( "Found a plugin" )
			var new_plugin: Control = load( plugin[ 1 ] ).instantiate()
			nPlugins.add_child( new_plugin )


func _ready() -> void:
	process_plugins()
