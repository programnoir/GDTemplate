extends HBoxContainer

signal removed_bind

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLabelBindName: Label = get_node( "LabelBindName" )
@onready var nButtonRemoveBind: Button = get_node( "ButtonRemoveBind" )

var action: String
var event: InputEvent


func set_action_name( new_name: String ) -> void:
	action = new_name


func set_bind_name( new_name: String ) -> void:
	nLabelBindName.text = new_name


func set_input_event( new_event: InputEvent ) -> void:
	event = new_event


func destroy() -> void:
	emit_signal( "removed_bind", action, event )
	nSignals.remove_signals()
	if( is_queued_for_deletion() == false ):
		queue_free()
