extends HBoxContainer
class_name HBCNumber

signal value_changed

@onready var nLabelValue: Label = get_node( "LabelValue" )
@onready var nSpinBoxValue: SpinBox = get_node( "SpinBoxValue" )
@onready var nSpinBoxLineEdit: LineEdit = nSpinBoxValue.get_line_edit()
@onready var nButtonToggleEditValue: Button = get_node(
		"ButtonToggleEditValue" )

@export var value: int = 0
@export var min_value: int = 0
@export var max_value: int = 100
@export var default_label: String = "edit"
@export var toggled_label: String = "confirm"


func _unhandled_key_input( event: InputEvent ) -> void:
	if( nButtonToggleEditValue.has_focus() == false ):
		return
	if( nSpinBoxLineEdit.has_focus() == false ):
		return
	#	End defensive return: Not focused.
	var focus_target: Control = self
	if( Input.is_action_just_pressed( "ui_up" ) ):
		focus_target = owner.focus_neighbor_top
	elif( Input.is_action_just_pressed( "ui_down" ) ):
		focus_target = owner.focus_neighbor_bottom
	elif( Input.is_action_just_pressed( "ui_focus_prev" ) ):
		if( nSpinBoxValue.visible == false || nSpinBoxLineEdit.has_focus() ):
			focus_target = owner.focus_previous
	elif( Input.is_action_just_pressed( "ui_focus_next" ) ):
		if( nButtonToggleEditValue.has_focus() ):
			focus_target = owner.focus_next
	focus_target.grab_focus()


func _on_focus_entered() -> void:
	nButtonToggleEditValue.grab_focus()


func _on_button_toggle_edit_value_toggled( button_pressed: bool ) -> void:
	nLabelValue.visible = not button_pressed
	nSpinBoxValue.visible = button_pressed
	if( nSpinBoxValue.visible ):
		nButtonToggleEditValue.focus_neighbor_left = \
				nSpinBoxLineEdit.get_path()
		nButtonToggleEditValue.text = tr( toggled_label )
		nSpinBoxLineEdit.grab_focus()
	else:
		nButtonToggleEditValue.focus_neighbor_left = \
				nButtonToggleEditValue.get_path()
		value = nSpinBoxValue.value
		set_value_silent( value )
		nButtonToggleEditValue.text = tr( default_label )
		nButtonToggleEditValue.grab_focus()
		emit_signal( "value_changed", value )


func set_value_silent( new_value: int ) -> void:
	nLabelValue.text = str( new_value )
	nSpinBoxValue.set_value_no_signal( new_value )


func _ready() -> void:
	set_focus_mode( Control.FOCUS_ALL )
	nButtonToggleEditValue.text = tr( default_label )
