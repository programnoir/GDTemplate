extends VBoxContainer

@onready var nHSliderVolumeMain: HSliderVolume = get_node(
	"HBCAudio/GCVolume/HSliderVolumeMain" )
@onready var nHSliderVolumeMusic: HSliderVolume = get_node(
	"HBCAudio/GCVolume/HSliderVolumeMusic" )
@onready var nHSliderVolumeSFX: HSliderVolume = get_node(
	"HBCAudio/GCVolume/HSliderVolumeSFX" )
@onready var nHSliderVolumeVoice: HSliderVolume = get_node(
	"HBCAudio/GCVolume/HSliderVolumeVoice" )

var audio_sliders: Array = []


func add_plugin_setting( new_setting: Control ) -> void:
	add_child( new_setting )


func update_from_load() -> void:
	for i in audio_sliders.size():
		var bus_id: int = audio_sliders[ i ].BUS_ID
		if( GlobalUserSettings.audio.has( bus_id ) ):
			audio_sliders[ i ].value = GlobalUserSettings.audio[ bus_id ]


func _ready() -> void:
	audio_sliders.append( nHSliderVolumeMain )
	audio_sliders.append( nHSliderVolumeMusic )
	audio_sliders.append( nHSliderVolumeSFX )
	audio_sliders.append( nHSliderVolumeVoice )
