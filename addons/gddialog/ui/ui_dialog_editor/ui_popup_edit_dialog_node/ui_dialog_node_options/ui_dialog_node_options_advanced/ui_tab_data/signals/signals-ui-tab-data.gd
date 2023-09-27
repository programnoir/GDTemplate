@tool
extends Node


func _on_option_button_type_item_selected( index: int ) -> void:
	owner.nTabData.nOptionButtonCustomType.visible = ( index == 0 )
	owner.nTabData.nOptionButtonBuiltInType.visible = ( index == 1 )
	owner.nTabData.nOptionButtonVariable.visible = ( index == 1 )
	owner.nTabData.nLineEditCustomString.visible = ( index == 0 and 
			owner.nTabData.nOptionButtonCustomType.selected == 0 )
	owner.nTabData.nSpinBoxCustomFloat.visible = ( index == 0 and 
			owner.nTabData.nOptionButtonCustomType.selected == 1 )
	owner.nTabData.nLineEditCustomString.clear()
	owner.nTabData.nSpinBoxCustomFloat.value = 0


func _on_option_button_custom_type_item_selected( index: int ):
	owner.nTabData.nLineEditCustomString.visible = ( index == 0 )
	owner.nTabData.nSpinBoxCustomFloat.visible = ( index == 1 )
	owner.nTabData.nLineEditCustomString.clear()
	owner.nTabData.nSpinBoxCustomFloat.value = 0


func _on_option_button_built_in_type_item_selected( index: int ):
	owner.nTabData.populate_ui()


func _on_button_add_data_pressed() -> void:
	owner.nTabData.add_data_ui()
