extends VBoxContainer

@onready var nSignals: Node = get_node( "Signals" )
#	Control scheme profile selection
@onready var nOptionButtonProfile: OptionButton = get_node(
		"OptionButtonProfile" )
#	Profile controls
@onready var nGCProfiles: GridContainer = get_node(
		"GCProfiles" )
@onready var nButtonNewProfile: Button = nGCProfiles.get_node(
		"ButtonNewProfile" )
@onready var nButtonSaveProfile: Button = nGCProfiles.get_node(
		"ButtonSaveProfile" )
@onready var nButtonResetProfile: Button = nGCProfiles.get_node(
		"ButtonResetProfile" )
@onready var nButtonDeleteProfile: Button = nGCProfiles.get_node(
		"ButtonDeleteProfile" )
@onready var nSCActions: ScrollContainer = get_node( "SCActions" )
@onready var nVBCActions: VBoxContainer = get_node( 
		"SCActions/VBCActions" )
#	Managing Profiles
@onready var nUIPopupCreateProfile: PopupPanel = get_node(
		"UIPopupCreateProfile" )
#	Adding Binds
@onready var nUIPopupSetBind: PopupPanel = get_node( "UIPopupSetBind" )

var p_UIAction: PackedScene = preload(
		"res://ui/ui_settings/controls/ui_action/ui-action.tscn" )
var p_UIBind: PackedScene = preload(
		"res://ui/ui_settings/controls/ui_action/ui_bind/ui-bind.tscn" )

var current_profile: Dictionary = {}
var default_profile: Dictionary = {}
var selected_action: UIAction = null


func add_plugin_setting( new_setting: Control ) -> void:
	add_child( new_setting )


func _enter_tree() -> void:
	var actions: Array = InputMap.get_actions()
	#	Currently we're just loading actions by default.
	for action in actions:
		if( GlobalActionConfig.hide_list.has( action ) == false ):
			default_profile[ action ] = InputMap.action_get_events(
					action ).duplicate( true )


func set_new_action_bind( action: UIAction, bind: InputEvent ) -> void:
	var action_name: String = action.get_action_name()
	var new_bind: Control = p_UIBind.instantiate()
	current_profile[ action_name ].append( bind )
	action.add_bind( new_bind, bind )
	new_bind.removed_bind.connect( 
			Callable( nSignals, "_on_removed_bind" ) )
	selected_action.reassign_focus()
	InputMap.action_add_event( action_name, bind )


func scroll_to_focused_node( node_position_y: int ) -> void:
	var scrollwindow_height: int = nSCActions.size.y as int
	var scrollcontent_height: int = nVBCActions.size.y as int
	@warning_ignore( "integer_division" )
	var focused_y: int = node_position_y - ( scrollwindow_height / 2 ) as int 
	focused_y = clamp( focused_y, 0,
			scrollcontent_height - scrollwindow_height )
	nSCActions.set_v_scroll( focused_y )


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
		var new_action: Control = p_UIAction.instantiate()
		nVBCActions.add_child( new_action )
		new_action.set_action_name( action_name )
		new_action.set_display_name( tr( action_name ) )
		new_action.adding_bind.connect(
				Callable( nSignals, "_on_adding_bind" ) )
		new_action.focus_entered.connect(
				Callable( nSignals, "_on_action_bind_focus_entered" ) )
		var action_binds: Array = current_profile[ action_name ]
		for bind in action_binds:
			var new_bind: Control = p_UIBind.instantiate()
			new_action.add_bind( new_bind, bind )
			new_bind.removed_bind.connect( 
					Callable( nSignals, "_on_removed_bind" ) )


#	First-time setup - loading default profile.
func populate_action_list() -> void:
	current_profile.clear()
	current_profile = default_profile.duplicate( true )
	repopulate_action_list()


func select_input_profile( index: int ) -> void:
	if( index == 0 ):
		current_profile.clear()
		current_profile = default_profile.duplicate( true )
	else:
		var profile_name: String = nOptionButtonProfile.get_item_text( index )
		if( GlobalUserSettings.select_input_profile( profile_name ) == true ):
			current_profile.clear()
			current_profile = GlobalUserSettings.get_input_profile(
					index ).duplicate( true )
	repopulate_action_list()


func repopulate_profiles() -> void:
	nOptionButtonProfile.clear()
	nOptionButtonProfile.add_item( tr( "profile_default" ) )
	for profile_name in GlobalUserSettings.get_input_profile_names():
		nOptionButtonProfile.add_item( profile_name )


func save_changes_to_profile() -> void:
	GlobalUserSettings.save_changes_to_profile(
			nOptionButtonProfile.selected, current_profile )


func revert_changes_to_profile() -> void:
	select_input_profile( nOptionButtonProfile.selected )


func update_profile_buttons() -> void:
	var default: bool = nOptionButtonProfile.selected == 0
	owner.nTabControls.nButtonSaveProfile.disabled = default
	owner.nTabControls.nButtonResetProfile.disabled = default
	owner.nTabControls.nButtonDeleteProfile.disabled = default


func create_input_profile( profile_name: String ) -> void:
	#	First, add duplicate of *current* data to GlobalUserSettings
	GlobalUserSettings.add_input_profile( profile_name, current_profile )
	#	Next, add option to profile dropdown, select it, and save.
	nOptionButtonProfile.add_item( profile_name )
	nOptionButtonProfile.select( nOptionButtonProfile.item_count - 1 )
	nOptionButtonProfile.grab_focus()
	update_profile_buttons()
	GlobalUserSettings.save_settings()


func delete_current_profile() -> void:
	var current_profile_id = nOptionButtonProfile.selected
	if( current_profile_id == 0 ):
		return
	#	End defensive return: Cannot delete default profile.
	GlobalUserSettings.delete_input_profile( current_profile_id - 1 )
	nOptionButtonProfile.select( 0 )
	select_input_profile( 0 )
	nOptionButtonProfile.remove_item( current_profile_id )
	update_profile_buttons()


func update_from_load() -> void:
	var profile_index: int = GlobalUserSettings.get_current_input_profile()
	repopulate_profiles()
	select_input_profile( profile_index )
	nOptionButtonProfile.selected = profile_index
	repopulate_action_list()


func destroy() -> void:
	clear_action_list()
	if( is_queued_for_deletion() == false ):
		queue_free()
