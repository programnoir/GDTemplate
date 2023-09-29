@tool
extends ColorRect
class_name DialogRecordRow

signal toggle_checked_record( record_row, checked )
signal renamed_record( record_row, old_name, new_name )
signal changed_record_description( record_id, new_text )
signal edit_record( record_id )

@onready var nCheckBox = get_node( "HBoxContainer/CheckBox" )
@onready var nLabelID = get_node( "HBoxContainer/LabelID" )
@onready var nLineEditRecordName = get_node( "HBoxContainer" \
		+ "/LineEditRecordName" )
@onready var nMenuButtonTags = get_node( "HBoxContainer" \
		+ "/MenuButtonTags" )
@onready var nLineEditDescription = self.get_node( "HBoxContainer" \
		+ "/LineEditDescription" )

var id: int = -1
var name_backup: String = ""
var description_backup: String = ""


func set_record_id( new_id: int ) -> void:
	id = new_id
	nLabelID.text = str( new_id )


func get_record_id() -> int:
	return id


func set_record_checked( new_value: bool ) -> void:
	nCheckBox.button_pressed = new_value


func set_record_name_field( new_label: String ) -> void:
	nLineEditRecordName.text = new_label


func set_record_description( new_text: String ) -> void:
	nLineEditDescription.text = new_text


func add_tag_to_tag_list( tag_name: String ) -> void:
	nMenuButtonTags.get_popup().add_item( tag_name )


func remove_tag_from_tag_list( tag_name: String ) -> void:
	var nMenuButtonTagsPopup = nMenuButtonTags.get_popup()
	for tag in range( nMenuButtonTagsPopup.get_item_count() ):
		if( tag_name == nMenuButtonTagsPopup.get_item_text( tag ) ):
			#	Tag found. Remove and exit.
			nMenuButtonTagsPopup.remove_item( tag )
			break


func destroy() -> void:
	queue_free()
