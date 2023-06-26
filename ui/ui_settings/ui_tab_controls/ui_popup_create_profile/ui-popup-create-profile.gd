extends PopupPanel

@onready var nUILineEditProfileName = get_node(
		"VBCCreateProfile/UILineEditProfileName" )


func create_input_profile() -> void:
	if( nUILineEditProfileName.text == "" ):
		return
	if( nUILineEditProfileName.text == "default" ):
		#	Nice try.
		return
	if(
		UserSettings.input_profiles[ "profile_names" ].has(
			nUILineEditProfileName.text )
	):
		return
	#	Should probably make a popup window stating that they can't set that name.
	visible = false
	owner.nUITabControls.create_input_profile( nUILineEditProfileName.text )
	nUILineEditProfileName.clear()
