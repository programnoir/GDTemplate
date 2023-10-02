extends Node


var dialog_types: Dictionary = {
	"End": Callable( self, "end_dialog" ),
	"Line": Callable( self, "line_dialog" ),
	"Advanced": Callable( self, "advanced_dialog" ),
	"If": Callable( self, "if_dialog" ),
	"Set": Callable( self, "set_dialog" ),
	"Set GUI": Callable( self, "set_gui_dialog" ),
	"Run Script": Callable( self, "run_script" )
}


func end_dialog() -> void:
	owner.nRichTextLabelDialog.text = ""
	owner.visible = false
	owner.emit_signal( "toggle_visible", false )


func process_node() -> void:
	owner.node_type = owner.reader.get_node_type(
			owner.record_id, owner.node_id )
	dialog_types[ owner.node_type ].call()
