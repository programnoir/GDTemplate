extends PopupPanel

@onready var cSig: Node = $cSig
@onready var nUILabelActionName: Label = $VBCNewBind/UILabelActionName
@onready var nUILineEditBindName: LineEdit = $VBCNewBind/UILabelBindName
@onready var nUIButtonSetBind: Button = get_node(
		"VBCNewBind/HBCBindOptions/UIButtonSetBind" )

var awaiting_input: bool = false

#	Which action are we binding?
var current_action: UIAction
#	Which event are we about to bind?
var current_event: InputEvent


func set_event( event: InputEvent ) -> void:
	nUIButtonSetBind.disabled = false
	current_event = event
	nUILineEditBindName.text = current_event.as_text()
	nUIButtonSetBind.grab_focus()


func read_new_bind_input( action: UIAction ) -> void:
	nUIButtonSetBind.disabled = true
	current_action = action
	nUILabelActionName.text = current_action.get_action_name()
	nUILineEditBindName.grab_focus()
	nUILineEditBindName.text = "Listening for input..."
	current_event = null
	cSig.set_process_input( true )
	awaiting_input = true


func send_new_action_bind( action: UIAction, event: InputEvent ) -> void:
	owner.nUITabControls.set_new_action_bind( action, event )
	visible = false
