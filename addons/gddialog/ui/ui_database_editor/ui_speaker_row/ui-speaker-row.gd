@tool
extends ColorRect
class_name DialogSpeakerRow

signal name_modified( current_name, new_name, row )
signal value_modified( color_name, new_value )
signal destroyed( row )

@onready var nLineEditSpeakerName: LineEdit = self.get_node( "HBoxContainer"\
		+ "/LineEditSpeakerName" )
@onready var nColorPickerButton: ColorPickerButton = self.get_node(
		"HBoxContainer/ColorPickerButton" )

var last_saved_name: String = ""


func get_speaker_name() -> String:
	return nLineEditSpeakerName.text


func set_last_saved_name( new_name: String ) -> void:
	last_saved_name = new_name


func set_name_ui( new_name: String ) -> void:
	nLineEditSpeakerName.text = new_name


func change_name( new_name: String ) -> void:
	if( new_name == "" ):
		set_name_ui( last_saved_name )
		return
	emit_signal( "name_modified", last_saved_name, new_name, self )


func reset_name_ui() -> void:
	nLineEditSpeakerName.text = last_saved_name


func set_value_ui( new_value: Color ) -> void:
	nColorPickerButton.color = new_value


func destroy() -> void:
	queue_free()
