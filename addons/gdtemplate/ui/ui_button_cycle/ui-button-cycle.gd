extends Button
class_name ButtonCycle

signal new_index

var list: Array = []
var current_index: int = 0


func get_list() -> Array:
	return list


func set_index( increment: int = 0 ) -> void:
	if( current_index + increment > list.size() - 1 ):
		current_index = 0
	elif( current_index + increment < 0 ):
		current_index = max( 0, list.size() - 1 )
	else:
		current_index += increment
	text = list[ current_index ]
	emit_signal( "new_index", current_index )


#	Internally changes the current index without changing font.
func set_index_manual( new_index: int ) -> void:
	current_index = new_index


func _unhandled_key_input( event: InputEvent ) -> void:
	if( has_focus() == false ):
		return
	#	End defensive return: Not focused.
	var increment: int = 0
	if( Input.is_action_just_released( "ui_right" ) ):
		increment = 1
	if( Input.is_action_just_released( "ui_left" ) ):
		increment -= 1
	if( increment == 0 ):
		return
	#	End defensive return: Not selecting anything
	set_index( increment )


func set_list( new_list: Array ) -> void:
	list = new_list
	text = list[ 0 ]
