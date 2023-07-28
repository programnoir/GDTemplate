extends Button
class_name ButtonTab
## Button-based alternative to TabContainer and Tabs.
##
## TabContainer and Tab nodes lack keyboard accessibility, hence the creation of
## this button-based alternative. Clicking and focusing a tab will hide other
## tabs and only show the tab associated with this ButtonTab.
"""
Notes:
	No notes.
Debug Info:
	No debug info.
"""
## Reference to the content that is associated with this ButtonTab.
@export var n_VBCTab: VBoxContainer = null


func _on_focus_entered() -> void:
	if( n_VBCTab == null ):
		print( "No tab for this ButtonTab. This ButtonTab = %s", text )
		return
	#	End defensive return: ButtonTab content not set.
	elif( n_VBCTab.visible == true ):
		return
	#	End defensive return: ButtonTab already selected.
	var buttons: Array = get_tree().get_nodes_in_group(
				"GroupSettingsTabButtons" )
	for button in buttons:
		button.n_VBCTab.visible = false
	n_VBCTab.visible = true


func _ready() -> void:
	visible = true
