extends VBoxContainer
class_name UIAction

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLabelActionName: Label = get_node(
		"PanelContainer/Panel/HBCActionName/LabelActionName" )
@onready var nButtonAddBind: Button = get_node(
		"PanelContainer/Panel/HBCActionName/ButtonAddBind" )
@onready var nVBCBinds: VBoxContainer = get_node( "VBCBinds" )

signal adding_bind

#	Action's name
var this_name: String = ""

func get_action_name() -> String:
	return this_name


func set_action_name( new_name: String ) -> void:
	this_name = new_name


func set_display_name( new_name: String ) -> void:
	nLabelActionName.text = new_name


func reassign_focus() -> void:
	nButtonAddBind.grab_focus()


func add_bind( new_bind: Control, bind_event: InputEvent ) -> void:
	add_child( new_bind )
	var bind_name: String = bind_event.as_text()
	new_bind.set_action_name( get_action_name() )
	new_bind.set_bind_name( bind_name )
	new_bind.set_input_event( bind_event )
	new_bind.focus_entered.connect( Callable( nSignals,
				"_on_button_bind_focus_entered" ) )


func _ready() -> void:
	for bind in nVBCBinds.get_children():
		bind.focus_entered.connect( Callable( nSignals,
				"_on_button_bind_focus_entered" ) )


func destroy() -> void:
	var binds: Array = nVBCBinds.get_children()
	for bind in binds:
		bind.destroy()
	if( is_queued_for_deletion() == false ):
		queue_free()
