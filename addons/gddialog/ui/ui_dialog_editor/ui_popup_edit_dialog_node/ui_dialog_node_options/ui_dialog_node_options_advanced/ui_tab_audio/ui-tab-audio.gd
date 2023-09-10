@tool
extends VBoxContainer

@onready var nLineEditPathSFX: LineEdit = get_node(
		"GridContainer/LineEditPathSFX" )
@onready var nLineEditPathTypewriter: LineEdit = get_node(
		"GridContainer/LineEditPathTypewriter" )
@onready var nLineEditPathSong: LineEdit = get_node(
		"GridContainer/HBCSong/LineEditPathSong" )
@onready var nOptionButtonTransition: OptionButton = get_node(
		"GridContainer/HBCSong/OptionButtonTransition" )


func save_current_keyframe( data: Dictionary ) -> void:
	data[ "sound_effect" ] = nLineEditPathSFX.text
	data[ "sound_typewriter" ] = nLineEditPathTypewriter.text
	data[ "music" ] = nLineEditPathSong.text
	data[ "music_transition" ] = nOptionButtonTransition.get_item_text(
			nOptionButtonTransition.selected )


func load_current_keyframe() -> void:
	nLineEditPathSFX.text = owner.get_keyframe_property( "sound_effect" )
	nLineEditPathTypewriter.text = owner.get_keyframe_property(
			"sound_typewriter" )
	nLineEditPathSong.text = owner.get_keyframe_property( "music" )
	owner.select_by_text( nOptionButtonTransition,
			owner.get_keyframe_property( "music_transition" ) )
