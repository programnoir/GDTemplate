extends Panel

@onready var nSignals: Node = get_node( "Signals" )
@onready var nRichTextLabelResponse: RichTextLabel = get_node(
		"HBoxContainer/RichTextLabelResponse" )

var responses: Array = []
var current_index: int = 0


func disable() -> void:
	visible = false
	nSignals.set_process_unhandled_input( false )


func get_slot() -> int:
	return current_index


func update_responses( index_increment: int ) -> void:
	current_index = clamp( current_index + index_increment, 0,
			responses.size() - 1 )
	nRichTextLabelResponse.clear()
	nRichTextLabelResponse.add_text( responses[ current_index ] )


func setup_responses( new_responses: Array ) -> void:
	visible = true
	responses = new_responses.duplicate( true )
	current_index = 0
	nRichTextLabelResponse.clear()
	nRichTextLabelResponse.add_text( responses[ 0 ] )
	nSignals.set_process_unhandled_input( true )
