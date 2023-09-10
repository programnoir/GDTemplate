@tool
extends DialogNodeOptions
class_name DialogNodeOptionsSetGUI

@onready var nLineEditGUIType: LineEdit = get_node( "LineEditGUIType" )


func write_node_data() -> void:
	node_data[ "gui_type" ] = nLineEditGUIType.text


func populate_ui() -> void:
	if( node_data.size() == 0 ):
		return
	#	End defensive return: No data yet.
	nLineEditGUIType.text = node_data[ "gui_type" ]
	super()
