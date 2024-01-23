extends PopupPanel

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLabelActionName: Label = get_node( "VBCNewBind/LabelActionName" )
@onready var nLineEditBindName: LineEdit = get_node(
		"VBCNewBind/LineEditBindName" )
@onready var nButtonSetBind: Button = get_node(
		"VBCNewBind/HBCBindOptions/ButtonSetBind" )

var awaiting_input: bool = false

#	Which action are we binding?
var current_action: UIAction
#	Which event are we about to bind?
var current_event: InputEvent


func set_event( event: InputEvent ) -> void:
	nButtonSetBind.disabled = false
	current_event = event
	nLineEditBindName.text = GlobalActionConfig.find_replaces(
			current_event.as_text() )
	nLineEditBindName.editable = false
	nButtonSetBind.grab_focus()


func read_new_bind_input( action: UIAction ) -> void:
	nButtonSetBind.disabled = true
	nLineEditBindName.editable = true
	nLineEditBindName.placeholder_text = tr( "ui_lineedit_listening" )
	current_action = action
	nLabelActionName.text = current_action.get_action_name()
	nLineEditBindName.grab_focus()
	nLineEditBindName.text = tr( "ui_lineedit_listening" )
	current_event = null
	nSignals.set_process_input( true )
	awaiting_input = true


func send_new_action_bind( action: UIAction, event: InputEvent ) -> void:
	owner.nTabControls.set_new_action_bind( action, event )
	visible = false
