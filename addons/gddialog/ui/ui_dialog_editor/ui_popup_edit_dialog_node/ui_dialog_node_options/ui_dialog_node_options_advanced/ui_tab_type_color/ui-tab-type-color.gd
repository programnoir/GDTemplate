@tool
extends VBoxContainer

@onready var nOptionButtonTextType: OptionButton = get_node(
		"VBoxContainer/HBCTextType/OptionButtonTextType" )
@onready var nCheckBoxUseColor: CheckBox = get_node(
		"VBoxContainer/HBCColorOptions/CheckBoxUseColor")
@onready var nOptionButtonColor: OptionButton = get_node(
		"VBoxContainer/HBCColorOptions/OptionButtonColor" )
@onready var nColorPickerButton: ColorPickerButton = get_node(
		"VBoxContainer/HBCColorOptions/ColorPickerButton" )


func save_current_keyframe( data: Dictionary ) -> void:
	data[ "text_type" ] = nOptionButtonTextType.get_item_text(
			nOptionButtonTextType.selected )
	data[ "using_text_color" ] = nCheckBoxUseColor.button_pressed
	data[ "text_color" ] = nOptionButtonColor.get_item_text(
			nOptionButtonColor.selected )
	if( data[ "text_color" ] == "Custom" ):
		data[ "text_color_custom" ] = nColorPickerButton.color
	else:
		#	No sense wasting space when we can reference it in a reader later.
		data[ "text_color_custom" ] = null


func load_current_keyframe() -> void:
	var selected_color: String = owner.get_keyframe_property( "text_color" )
	owner.select_by_text( nOptionButtonTextType,
			owner.get_keyframe_property( "text_type" ) )
	owner.select_by_text( nOptionButtonColor, selected_color )
	nCheckBoxUseColor.button_pressed = owner.get_keyframe_property(
			"using_text_color" )
	if( selected_color == "Custom" ):
		nColorPickerButton.color = owner.get_keyframe_property(
				"text_color_custom" )
	else:
		nColorPickerButton.color = owner.colors_list[ selected_color ]


func populate_ui() -> void:
	for color_item in owner.colors_array.keys():
		nOptionButtonColor.add_item( color_item )
