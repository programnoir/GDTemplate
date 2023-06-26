extends VBoxContainer

#	Screw this, I'm replacing this with buttons.
#	TabBar is not keyboard accessible.

@onready var cSig: Node = get_node( "cSig" )
#	Control scheme profile selection
@onready var nUIOptionButtonProfile: OptionButton = get_node(
		"UIOptionButtonProfile" )
#	Profile controls
@onready var nGCProfiles: GridContainer = get_node(
		"CCProfiles/GCProfiles" )
@onready var nUIButtonNewProfile: Button = nGCProfiles.get_node(
		"UIButtonNewProfile" )
@onready var nUIButtonSaveProfile: Button = nGCProfiles.get_node(
		"UIButtonSaveProfile" )
@onready var nUIButtonResetProfile: Button = nGCProfiles.get_node(
		"UIButtonResetProfile" )
@onready var nUIButtonDeleteProfile: Button = nGCProfiles.get_node(
		"UIButtonDeleteProfile" )
@onready var nUISCActions: ScrollContainer = get_node( "UISCActions" )
@onready var nVBCActions: VBoxContainer = get_node( 
		"UISCActions/VBCActions" )
#	Managing Profiles
@onready var nUIPopupCreateProfile: PopupPanel = get_node(
		"UIPopupCreateProfile" )
#	Adding Binds
@onready var nUIPopupSetBind: PopupPanel = get_node( "UIPopupSetBind" )

var pUIAction: PackedScene = preload(
		"res://ui/ui_settings/ui_tab_controls/ui_action/ui-action.tscn" )
var pUIBind: PackedScene = preload(
		"res://ui/ui_settings/ui_tab_controls/ui_action/ui_bind/ui-bind.tscn" )

var current_profile: Dictionary = {}
var default_profile: Dictionary = {}
var selected_action: UIAction = null


func set_new_action_bind( action: UIAction, bind: InputEvent ) -> void:
	var action_name: String = action.get_action_name()
	current_profile[ action_name ].append( bind )
	var new_bind: Control = pUIBind.instantiate()
	action.add_bind( new_bind, bind )
	new_bind.removed_bind.connect( 
			Callable( cSig, "_on_removed_bind" ) )
	selected_action.reassign_focus()
	InputMap.action_add_event( action_name, bind )
	#	Do not save here.


func scroll_to_focused_node( node_position_y: int ) -> void:
	@warning_ignore("narrowing_conversion")
	var scrollwindow_height: int = nUISCActions.size.y
	@warning_ignore("narrowing_conversion")
	var scrollcontent_height: int = nVBCActions.size.y
	@warning_ignore("integer_division")
	var focused_y: int = node_position_y - ( scrollwindow_height / 2 )
	focused_y = clamp( focused_y, 0,
			scrollcontent_height - scrollwindow_height )
	nUISCActions.set_v_scroll( focused_y )


func remove_bind_from_action( action_name: String, bind: InputEvent ) -> void:
	InputMap.action_erase_event( action_name, bind )
	current_profile[ action_name ].erase( bind )


func read_new_bind_input( action: UIAction ) -> void:
	selected_action = action
	nUIPopupSetBind.popup_centered()
	nUIPopupSetBind.read_new_bind_input( action )


func clear_action_list() -> void:
	var actions: Array = nVBCActions.get_children()
	for action in actions:
		action.destroy()


func repopulate_action_list() -> void:
	clear_action_list()
		#	Use the default_profile dictionary to set the input map.
	for action_name in default_profile.keys():
		var new_action: Control = pUIAction.instantiate()
		nVBCActions.add_child( new_action )
		new_action.set_action_name( action_name )
		if( ActionIgnoreList.rename_list.has( action_name ) ):
			new_action.set_display_name(
						ActionIgnoreList.rename_list[ action_name ] )
		else:
			new_action.set_display_name( action_name )
		new_action.adding_bind.connect(
				Callable( cSig, "_on_adding_bind" ) )
		new_action.focus_entered.connect(
				Callable( cSig, "_on_action_bind_focus_entered" ) )
		var action_binds: Array = current_profile[ action_name ]
		for bind in action_binds:
			var new_bind: Control = pUIBind.instantiate()
			new_action.add_bind( new_bind, bind )
			new_bind.removed_bind.connect( 
					Callable( cSig, "_on_removed_bind" ) )


#	Not sure if this is needed.
func populate_action_list() -> void:
	#	This is for first-time setup.
	current_profile.clear()
	#	needs to be fixed - I never used selected_profile, it's always 0.
	current_profile = default_profile.duplicate( true )
	repopulate_action_list()


func select_input_profile( index: int ) -> void:
	if( index == 0 ):
		current_profile.clear()
		current_profile = default_profile.duplicate( true )
	else:
		var profile_name: String = nUIOptionButtonProfile.get_item_text( index )
		#	If there IS a profile
		if( UserSettings.select_input_profile( profile_name ) == true ):
			current_profile.clear()
			current_profile = UserSettings.get_input_profile(
					index ).duplicate( true )
	repopulate_action_list()
	#UserSettings.set_current_input_profile( profi )


func repopulate_profiles() -> void:
	nUIOptionButtonProfile.clear()
	nUIOptionButtonProfile.add_item( "default" )
	for profile_name in UserSettings.get_input_profile_names():
		nUIOptionButtonProfile.add_item( profile_name )
	#	TODO: look up saved profiles and set to the selected one.


func save_changes_to_profile() -> void:
	UserSettings.save_changes_to_profile(
			nUIOptionButtonProfile.selected, current_profile )


func revert_changes_to_profile() -> void:
	select_input_profile( nUIOptionButtonProfile.selected )


func update_profile_buttons() -> void:
	var default: bool = nUIOptionButtonProfile.selected == 0
	owner.nUITabControls.nUIButtonSaveProfile.disabled = default
	owner.nUITabControls.nUIButtonResetProfile.disabled = default
	owner.nUITabControls.nUIButtonDeleteProfile.disabled = default


func create_input_profile( profile_name: String ) -> void:
	#	First, add duplicate of *current* data to UserSettings
	UserSettings.add_input_profile( profile_name, current_profile )
	#	Next, add option to profile dropdown and select it.
	nUIOptionButtonProfile.add_item( profile_name )
	nUIOptionButtonProfile.select( nUIOptionButtonProfile.item_count - 1 )
	nUIOptionButtonProfile.grab_focus()
	update_profile_buttons()
	#	Finally, save UserSettings
	UserSettings.save_settings()


func delete_current_profile() -> void:
	var current_profile_id = nUIOptionButtonProfile.selected
	if( current_profile_id == 0 ):
		#	Wat. How did you get here?
		return
	UserSettings.delete_input_profile( current_profile_id - 1 )
	nUIOptionButtonProfile.select( 0 )
	select_input_profile( 0 )
	nUIOptionButtonProfile.remove_item( current_profile_id )
	update_profile_buttons()


func update_from_load() -> void:
	repopulate_profiles()
	var profile_index: int = UserSettings.get_current_input_profile()
	select_input_profile( profile_index )
	nUIOptionButtonProfile.selected = profile_index
	repopulate_action_list()


func _ready() -> void:
	var actions: Array = InputMap.get_actions()
	#	Currently we're just loading by default.
	for action in actions:
		if( ActionIgnoreList.hide_list.has( action ) ):
			continue
		else:
			default_profile[ action ] = InputMap.action_get_events(
					action ).duplicate( true )
	#	Next, we load in the alternative profiles
	#	After that, we assign the profile according to UserSettings.


func destroy() -> void:
	clear_action_list()
	if( is_queued_for_deletion() == false ):
		queue_free()
