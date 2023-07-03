extends PopupPanel

@onready var nLineEditProfileName = get_node(
		"VBCCreateProfile/LineEditProfileName" )


func create_input_profile() -> void:
	if( nLineEditProfileName.text == "" ):
		return
	#	End defensive return: No profile name specified.
	if( nLineEditProfileName.text == "default" ):
		return
	#	End defensive return: Don't set it to default.
	if(
		GlobalUserSettings.input_profiles[ "profile_names" ].has(
			nLineEditProfileName.text )
	):
		return
	#	End defensive return: Already exists. TODO: Add error message.
	visible = false
	owner.nTabControls.create_input_profile( nLineEditProfileName.text )
	nLineEditProfileName.clear()
