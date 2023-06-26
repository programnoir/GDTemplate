extends Button
class_name ButtonTab

@export var tab: VBoxContainer = null

func _on_focus_entered() -> void:
	if( tab == null ):
		print( "No tab for this ButtonTab. This ButtonTab = %s", text )
		return
	elif( tab.visible == true ):
		return
	var buttons: Array = get_tree().get_nodes_in_group(
				"GroupSettingsTabButtons" )
	for button in buttons:
		button.tab.visible = false
	tab.visible = true


func _ready() -> void:
	visible = true
