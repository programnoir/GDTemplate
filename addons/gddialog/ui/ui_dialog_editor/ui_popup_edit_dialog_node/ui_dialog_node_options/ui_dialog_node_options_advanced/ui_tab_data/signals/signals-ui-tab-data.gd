@tool
extends Node


func _on_option_button_type_item_selected( index: int ) -> void:
	owner.nOptionButtonCustomType.visible == ( index == 0 )
	owner.nOptionButtonBuiltInType.visible == ( index == 1 )
	owner.nOptionButtonVariable.visible == ( index == 1 )
	owner.nLineEditCustomString.visible == ( index == 0 and 
			owner.nOptionButtonCustomType.selected == 0 )
	owner.nSpinBoxCustomFloat.visible == ( index == 0 and 
			owner.nOptionButtonCustomType.selected == 1 )
	owner.nLineEditCustomString.clear()
	owner.nSpinBoxCustomFloat.value = 0


func _on_option_button_custom_type_item_selected( index: int ):
	owner.nLineEditCustomString.visible == ( index == 0 )
	owner.nSpinBoxCustomFloat.visible == ( index == 1 )
	owner.nLineEditCustomString.clear()
	owner.nSpinBoxCustomFloat.value = 0


func _on_option_button_built_in_type_item_selected( index: int ):
	owner.nTabData.populate_ui()


func _on_button_add_data_pressed() -> void:
	owner.nTabData.add_data_ui()
