@tool
extends HBoxContainer
class_name AnimationRow

@onready var nButtonDeleteRow: Button = get_node( "ButtonDeleteRow" )


func _on_button_delete_row_pressed() -> void:
	self.destroy()


func get_data() -> Dictionary:
	var data: Dictionary = {
			"id": get_node( "SpinBoxPortraitID" ).value,
			"animation": get_node( "LineEditAnimation" ).text
	}
	return data.duplicate()


func set_portrait_id( new_id: int ) -> void:
	get_node( "SpinBoxPortraitID" ).value = new_id


func set_animation( new_animation: String ) -> void:
	get_node( "LineEditAnimation" ).text = new_animation


func _ready() -> void:
	nButtonDeleteRow.pressed.connect( Callable( self,
			"_on_button_delete_row_pressed" ) )


func destroy() -> void:
	nButtonDeleteRow.pressed.disconnect( Callable( self,
			"_on_button_delete_row_pressed" ) )
	self.queue_free()
