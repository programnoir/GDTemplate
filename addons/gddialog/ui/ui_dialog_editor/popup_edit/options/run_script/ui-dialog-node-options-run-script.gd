@tool
extends DialogNodeOptions
class_name DialogNodeOptionsRunScript

@onready var nLineEditFilePath: LineEdit = get_node( "LineEditFilePath" )
@onready var nLineEditScriptName: LineEdit = get_node( "LineEditScriptName" )


func write_node_data() -> void:
	node_data[ "script_filepath" ] = nLineEditFilePath.text
	node_data[ "script_funcref" ] = nLineEditScriptName.text


func populate_ui() -> void:
	if( node_data.size() == 0 ):
		return
	#	End defensive return: No data yet.
	nLineEditFilePath.text = node_data[ "script_filepath" ]
	nLineEditScriptName.text = node_data[ "script_funcref" ]
	super()
