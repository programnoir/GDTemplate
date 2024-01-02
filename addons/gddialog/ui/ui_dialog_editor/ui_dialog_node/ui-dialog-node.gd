@tool
extends GraphNode
class_name DialogNode

signal erased( this ) 
signal changed_size( node_id: int, new_size, new_vbc_size )
signal changed_offset( node_id: int, new_offset )

@onready var nVBCNodeEditor: VBoxContainer = get_node( "VBCNodeEditor" )
@onready var nLabelSummary: Label = nVBCNodeEditor.get_node( "LabelSummary" )

@export var type: String = "DialogNode"
@export var can_delete: bool = true
var node_id: int = 0
var vbc_size: Vector2
var resize_offset: Vector2 = Vector2( 0, 30 )


""" Signals """


func _on_ui_dialog_node_close_request() -> void:
	emit_signal( "erased", self )


func _on_ui_dialog_node_position_offset_changed() -> void:
	emit_signal( "changed_offset", node_id, position_offset )


func _on_ui_dialog_node_resize_request( new_minsize: Vector2 ) -> void:
	resize_node( new_minsize )


""" Signal Management """


func connect_all_signals() -> void:
	connect( "delete_request", Callable( self,
			"_on_ui_dialog_node_close_request" ) )
	connect( "position_offset_changed", Callable( self,
			"_on_ui_dialog_node_position_offset_changed" ) )
	connect( "resize_request", Callable( self,
			"_on_ui_dialog_node_resize_request" ) )


func disconnect_all_signals() -> void:
	disconnect( "delete_request", Callable( self,
			"_on_ui_dialog_node_close_request" ) )
	disconnect( "position_offset_changed", Callable( self,
			"_on_ui_dialog_node_position_offset_changed" ) )
	disconnect( "resize_request", Callable( self,
			"_on_ui_dialog_node_resize_request" ) )


""" Node ID and Name """


func set_node_id( new_node_id: int ) -> void:
	node_id = new_node_id
	title = "NID " + str( new_node_id )
	name = "NID " + str( new_node_id )


func get_type() -> String:
	return type


func set_type( new_type: String ) -> void:
	type = new_type


func get_summary() -> String:
	return nLabelSummary.text


func set_summary( new_text: String ) -> void:
	nLabelSummary.text = type + "\n" + new_text


func get_node_id() -> int:
	return node_id


#	Override function
func resize_node( new_minsize: Vector2 ) -> void:
	size.x = new_minsize.x
	size.y = new_minsize.y - resize_offset.y + resize_offset.y
	nVBCNodeEditor.custom_minimum_size.y = ( new_minsize.y - vbc_size.y
			+ resize_offset.y )
	emit_signal( "changed_size", node_id, size, nVBCNodeEditor.size )


func _ready() -> void:
	connect_all_signals()
	vbc_size = size - nVBCNodeEditor.size


func destroy() -> void:
	disconnect_all_signals()
	queue_free()
