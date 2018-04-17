extends Node

onready var weapon_top_position = get_node("weapon_top")
onready var weapon_top_front_position = get_node("weapon_top_front")
onready var weapon_front_position = get_node("weapon_front")
onready var weapon_bottom_front_position = get_node("weapon_bottom_front")
onready var weapon_bottom_position = get_node("weapon_bottom")

export(NodePath) var weapon_path
export var enabled = false

func has_weapon():
	return weapon_path != null
	
func get_weapon():
	return get_node(weapon_path)

func set_enabled(val):
	enabled = val
	get_weapon().visible = val

func _physics_process(delta):
	if(has_weapon() and enabled):
		if(Input.is_action_just_pressed("fire")):
			get_weapon().press_trigger()
		if(Input.is_action_pressed("fire")):
			get_weapon().hold_trigger()
		if(Input.is_action_just_released("fire")):
			get_weapon().release_trigger()
			
		if(Input.is_action_pressed("aim_up")):
			get_weapon().position = weapon_top_position.position
			get_weapon().rotation = weapon_top_position.rotation
		elif(Input.is_action_pressed("aim_down") and not get_parent().is_grounded()):
			get_weapon().position = weapon_bottom_position.position
			get_weapon().rotation = weapon_bottom_position.rotation
		elif(Input.is_action_pressed("aim_up_front")):
			get_weapon().position = weapon_top_front_position.position
			get_weapon().rotation = weapon_top_front_position.rotation
		elif(Input.is_action_pressed("aim_down_front")):
			get_weapon().position = weapon_bottom_front_position.position
			get_weapon().rotation = weapon_bottom_front_position.rotation
		else:
			get_weapon().position = weapon_front_position.position
			get_weapon().rotation = weapon_front_position.rotation