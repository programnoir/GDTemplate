@tool
extends VBoxContainer

@onready var nTextEditContext: TextEdit = $TextEditContext


func load_current_keyframe() -> void:
	nTextEditContext.clear()
	if( owner.node_data[ "keyframes" ][ owner.current_keyframe ].has( "context" ) == false ):
		return
	#	End defensive return: No context.
	var context: String = owner.get_keyframe_property( "context" )
	nTextEditContext.text = context


func save_current_keyframe( data: Dictionary ) -> void:
	data[ "context" ] = nTextEditContext.text
