@tool
extends VBoxContainer

@onready var nVBCAnimations: VBoxContainer = get_node(
		"SCAnimations/VBCAnimations" )

var p_animation_row: PackedScene = preload( "res://addons/gddialog/ui"\
		+ "/ui_dialog_editor/ui_popup_edit_dialog_node/ui_dialog_node_options"\
		+ "/ui_dialog_node_options_advanced/ui_tab_animations/ui_animation_row"\
		+ "/ui-animation-row.tscn" )


func save_current_keyframe( data: Dictionary ) -> void:
	var animations_list: Array = []
	for animation in nVBCAnimations.get_children():
		if( animation is AnimationRow ):
			animations_list.append( animation.get_data() )
	data[ "animations" ] = animations_list.duplicate()


func clear_animations() -> void:
	for animation in nVBCAnimations.get_children():
		if( animation is AnimationRow ):
			animation.destroy()


func add_animation_row() -> AnimationRow:
	var nAnimationRow: AnimationRow = p_animation_row.instantiate()
	nVBCAnimations.add_child( nAnimationRow )
	#	Move the child behind the button
	nVBCAnimations.move_child( nAnimationRow, max( 0,
				nVBCAnimations.get_children().size() - 2 ) )
	return nAnimationRow


func load_current_keyframe() -> void:
	clear_animations()
	var animations: Array = owner.get_keyframe_property( "animations" )
	for animation in animations:
		var new_animation: AnimationRow = add_animation_row()
		new_animation.set_portrait_id( animation[ "id" ] )
		new_animation.set_animation( animation[ "animation" ] )
