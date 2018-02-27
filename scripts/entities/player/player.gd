tool

extends "res://scripts/entities/player/playable_character.gd"

func _ready():
	pass

func _physics_process(delta):
	if(has_weapon()):
		if(Input.is_action_just_pressed("fire")):
			get_weapon().press_trigger()
		if(Input.is_action_pressed("fire")):
			get_weapon().hold_trigger()
		if(Input.is_action_just_released("fire")):
			get_weapon().release_trigger()
			
		if(Input.is_action_pressed("aim_up")):
			get_weapon().set_position(weapon_top_position.get_position())
			get_weapon().set_rotation(weapon_top_position.get_rotation())
		elif(Input.is_action_pressed("aim_down") and not is_grounded()):
			get_weapon().set_position(weapon_bottom_position.get_position())
			get_weapon().set_rotation(weapon_bottom_position.get_rotation())
		elif(Input.is_action_pressed("aim_up_front")):
			get_weapon().set_position(weapon_top_front_position.get_position())
			get_weapon().set_rotation(weapon_top_front_position.get_rotation())
		elif(Input.is_action_pressed("aim_down_front")):
			get_weapon().set_position(weapon_bottom_front_position.get_position())
			get_weapon().set_rotation(weapon_bottom_front_position.get_rotation())
		else:
			get_weapon().set_position(weapon_front_position.get_position())
			get_weapon().set_rotation(weapon_front_position.get_rotation())