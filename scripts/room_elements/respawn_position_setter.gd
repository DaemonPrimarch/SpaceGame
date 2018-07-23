extends "res://addons/player_enter_trigger/player_enter_trigger.gd"

export(NodePath) var position_path

func _ready():
	connect("player_entered", self, "_set_respawn_point_player")

func _set_respawn_point_player(player):
	player.get_node("respawn_manager").set_respawn_position(get_node(position_path).global_position)