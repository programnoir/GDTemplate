@tool
extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
@onready var nLineEditAddSpeaker: LineEdit = get_node(
		"HBCSpeakerOptions/LineEditAddSpeaker" )
@onready var nVBCSpeakers: VBoxContainer = get_node( "SCSpeakers/VBCSpeakers" )

var p_UISpeakerRow: PackedScene = preload( "res://addons/gddialog"\
		+ "/ui/ui_database_editor/ui_vbc_managers/ui_vbc_speaker_manager"\
		+ "/ui_speaker_row/ui-speaker-row.tscn" )


func create_speaker_variable(
		speaker_name: String,
		load: bool = false
) -> DialogSpeakerRow:
	if( load == false ):
		if( owner.nDatabase.add_speaker_variable( speaker_name ) == false ):
			return
		#	End defensive return: String exists/invalid
	var new_row: DialogSpeakerRow = p_UISpeakerRow.instantiate()
	nVBCSpeakers.add_child( new_row )
	new_row.set_name_ui( speaker_name )
	nSignals.connect_speaker_signals( new_row )
	nLineEditAddSpeaker.clear()
	owner.set_filename_label_modified( true )
	return new_row


func delete_speaker_variable( row: DialogSpeakerRow ) -> void:
	#	Disconnect signals
	nSignals.disconnect_speaker_signals( row )
	owner.nDatabase.delete_speaker_variable( row.get_speaker_name() )
	row.destroy()


func populate_speakers_in_manager() -> void:
	for speaker_row in owner.nDatabase.speakers_list.keys():
		var new_row: DialogSpeakerRow = create_speaker_variable(
				speaker_row, true )
		new_row.set_value_ui( owner.nDatabase.speakers_list[ speaker_row ] )


func clear_ui() -> void:
	for child in nVBCSpeakers.get_children():
		delete_speaker_variable( child )
