extends VBoxContainer

@onready var nUIHSliderVolumeMain: HSliderVolume = get_node(
	"HBCAudio/GridVolume/UIHSliderVolumeMain" )
@onready var nUIHSliderVolumeMusic: HSliderVolume = get_node(
	"HBCAudio/GridVolume/UIHSliderVolumeMusic" )
@onready var nUIHSliderVolumeSFX: HSliderVolume = get_node(
	"HBCAudio/GridVolume/UIHSliderVolumeSFX" )
@onready var nUIHSliderVolumeVoice: HSliderVolume = get_node(
	"HBCAudio/GridVolume/UIHSliderVolumeVoice" )

var audio_sliders: Array = []


func update_from_load() -> void:
	for i in audio_sliders.size():
		var bus_id = audio_sliders[ i ].bus_id
		if( UserSettings.audio.has( bus_id ) ):
			audio_sliders[ i ].value = UserSettings.audio[ bus_id ]


func _ready() -> void:
	audio_sliders.append( nUIHSliderVolumeMain )
	audio_sliders.append( nUIHSliderVolumeMusic )
	audio_sliders.append( nUIHSliderVolumeSFX )
	audio_sliders.append( nUIHSliderVolumeVoice )
