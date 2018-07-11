extends "cutscene_helper.gd"

export(NodePath) var character_path
export(NodePath) var player_path

export var character_speed = 0

var character
var player

func _ready():
	character = get_node(character_path)
	player = get_node(player_path)

func _physics_process(delta):
	if(player.global_position.x > character.global_position.x + 64 +32):
		player.set_movement_speed(character_speed + (player.global_position.x - character.global_position.x)/2)
	else:
		player.set_movement_speed(character_speed)