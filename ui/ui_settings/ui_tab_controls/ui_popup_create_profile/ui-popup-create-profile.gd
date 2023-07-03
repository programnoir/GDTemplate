extends PopupPanel

@onready var nLineEditProfileName = get_node(
		"VBCCreateProfile/LineEditProfileName" )


func create_input_profile() -> void:
	if( nLineEditProfileName.text == "" ):
		return
	if( nLineEditProfileName.text == "default" ):
		#	Nice try.
		return
	if(
		GlobalUserSettings.input_profiles[ "profile_names" ].has(
			nLineEditProfileName.text )
	):
		return
	#	Should probably make a popup window stating that they can't set that name.
	visible = false
	owner.nTabControls.create_input_profile( nLineEditProfileName.text )
	nLineEditProfileName.clear()
