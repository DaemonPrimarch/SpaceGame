extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var previous_players = {}

func _ready():
	get_tree().connect("tree_changed", self, "on_tree_change")
	on_tree_change()

func on_tree_change():
	if(is_inside_tree()):
		var players = get_tree().get_nodes_in_group("has_hp_bar")
		for player in previous_players:
			if(not player in players):
				remove_player(player)
		for player in players:
			if(not player in previous_players):
				add_player(player)

func add_player(player):
	var bar = load("res://nodes/hp_bar.tscn").instance();
	bar.set_name(player.get_name() + "_HP_bar")
	#Temporary solution
	bar.set_pos(Vector2(bar.get_pos().x, previous_players.size() * 35))
	bar.set_player(player)
	get_tree().get_root().call_deferred("add_child", bar)
	previous_players[player] = bar

func remove_player(player):
	var bar = previous_players[player]
	previous_players.erase(player)
	bar.destroy()