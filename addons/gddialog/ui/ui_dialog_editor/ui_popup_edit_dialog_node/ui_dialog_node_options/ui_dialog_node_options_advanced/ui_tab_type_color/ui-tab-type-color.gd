@tool
extends VBoxContainer

@onready var nOptionButtonTextType: OptionButton = get_node(
		"HBCTextType/OptionButtonTextType" )
@onready var nCheckBoxUseColor: CheckBox = get_node(
		"HBCColorOptions/CheckBoxUseColor")
@onready var nOptionButtonColor: OptionButton = get_node(
		"HBCColorOptions/OptionButtonColor" )
@onready var nColorPickerButton: ColorPickerButton = get_node(
		"HBCColorOptions/ColorPickerButton" )


func save_current_keyframe( data: Dictionary ) -> void:
	data[ "text_type" ] = nOptionButtonTextType.get_item_text(
			nOptionButtonTextType.selected )
	data[ "using_text_color" ] = nCheckBoxUseColor.button_pressed
	data[ "text_color" ] = nOptionButtonColor.get_item_text(
			nOptionButtonColor.selected )
	if( data[ "text_color" ] == "Custom" ):
		data[ "text_color_custom" ] = nColorPickerButton.color
	else:
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
		nColorPickerButton.disabled = false
	else:
		nColorPickerButton.color = owner.colors_array[ selected_color ]
		nColorPickerButton.disabled = true


func select_color( color_index: int ) -> void:
	var selected_color: String = nOptionButtonColor.get_item_text( color_index )
	if( selected_color == "Custom" ):
		nColorPickerButton.color = Color( 0.0, 0.0, 0.0, 1.0 )
		nColorPickerButton.disabled = false
	else:
		nColorPickerButton.color = owner.colors_array[ selected_color ]
		nColorPickerButton.disabled = true


func populate_ui() -> void:
	for color_item in owner.colors_array.keys():
		nOptionButtonColor.add_item( color_item )
