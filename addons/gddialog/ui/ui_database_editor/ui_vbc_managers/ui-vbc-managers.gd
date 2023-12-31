@tool
extends VBoxContainer

@onready var nLabelManagerTitle: Label = get_node(
		"HBCManagerTitle/LabelManagerTitle" )
@onready var nVBCArrayManager: VBoxContainer = get_node( "VBCArrayManager" )
@onready var nVBCColorManager: VBoxContainer = get_node( "VBCColorManager" )
@onready var nVBCFlagManager: VBoxContainer = get_node( "VBCFlagManager" )
@onready var nVBCFloatManager: VBoxContainer = get_node( "VBCFloatManager" )
@onready var nVBCSpeakerManager: VBoxContainer = get_node( "VBCSpeakerManager" )
@onready var nVBCStringManager: VBoxContainer = get_node( "VBCStringManager" )
@onready var nVBCTagManager: VBoxContainer = get_node( "VBCTagManager" )


func set_visible_manager( id: int ) -> void:
	visible = true
	nVBCTagManager.visible = ( id == 0 )
	nVBCFlagManager.visible = ( id == 2 )
	nVBCFloatManager.visible = ( id == 3 )
	nVBCStringManager.visible = ( id == 4 )
	nVBCArrayManager.visible = ( id == 5 )
	nVBCColorManager.visible = ( id == 7 )
	nVBCSpeakerManager.visible = ( id == 8 )
	match id:
		0:
			nLabelManagerTitle.text = "Tag Manager"
		2:
			nLabelManagerTitle.text = "Flag Manager"
		3:
			nLabelManagerTitle.text = "Float Manager"
		4:
			nLabelManagerTitle.text = "String Manager"
		5:
			nLabelManagerTitle.text = "Array Manager"
		7:
			nLabelManagerTitle.text = "Color Manager"
		8:
			nLabelManagerTitle.text = "Speaker Manager"


func populate_all_ui() -> void:
	nVBCArrayManager.populate_arrays_in_item_list()
	nVBCColorManager.populate_colors_in_manager()
	nVBCFlagManager.populate_flags_in_item_list()
	nVBCFloatManager.populate_floats_in_manager()
	nVBCSpeakerManager.populate_speakers_in_manager()
	nVBCStringManager.populate_strings_in_manager()
	nVBCTagManager.populate_tags_in_item_list()


func clear_ui() -> void:
	nVBCArrayManager.nItemListArrays.clear()
	nVBCColorManager.clear_ui()
	nVBCFlagManager.nItemListFlags.clear()
	nVBCFloatManager.clear_ui()
	nVBCSpeakerManager.clear_ui()
	nVBCStringManager.clear_ui()
	nVBCTagManager.nItemListTags.clear()
