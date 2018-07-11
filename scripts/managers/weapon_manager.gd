extends Node

export(NodePath) var weapon_path

export var enabled = false setget set_enabled

func has_weapon():
	return weapon_path != null
	
func get_weapon():
	return get_node(weapon_path)

func set_enabled(val):
	enabled = val
	if(is_inside_tree()):
		get_weapon().visible = val

func _ready():
	get_parent().add_to_group("handles_weapon")
	
	if(enabled):
		get_weapon().visible = true

func set_current_position(point):
	get_weapon().position = point.position
	get_weapon().rotation = point.rotation
	
func _physics_process(delta):
	if(has_weapon() and enabled):
		if(Input.is_action_just_pressed("fire")):
			get_weapon().press_trigger()
		if(Input.is_action_pressed("fire")):
			get_weapon().hold_trigger()
		if(Input.is_action_just_released("fire")):
			get_weapon().release_trigger()
			
		if(Input.is_action_pressed("aim_up")):
			set_current_position($weapon_top)
		elif(Input.is_action_pressed("aim_down") and not get_parent().is_grounded()):
			set_current_position($weapon_bottom)
		elif(Input.is_action_pressed("aim_up_front")):
			set_current_position($weapon_top_front)
		elif(Input.is_action_pressed("aim_down_front")):
			set_current_position($weapon_bottom_front)
		else:
			set_current_position($weapon_front)