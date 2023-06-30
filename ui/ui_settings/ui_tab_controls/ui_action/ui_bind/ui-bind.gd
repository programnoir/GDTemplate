extends HBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLabelBindName: Label = get_node( "LabelBindName" )
@onready var nButtonRemoveBind: Button = get_node( "ButtonRemoveBind" )

signal removed_bind

#	Debug? Remove later possibly. Unless I forgot during the refactor.
var this_name: String = ""

var action: String
var event: InputEvent


func set_action_name( new_name: String ) -> void:
	action = new_name


func set_bind_name( new_name: String ) -> void:
	nLabelBindName.text = new_name
	this_name = new_name


func set_input_event( new_event: InputEvent ) -> void:
	event = new_event


func destroy() -> void:
	#	Erase the event this bind is represented by.
	#InputMap.action_erase_event( action, event )
	emit_signal( "removed_bind", action, event )
	nSignals.remove_signals()
	if( is_queued_for_deletion() == false ):
		queue_free()
