extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var previous_players = {}

func _ready():
	print("HP bars loaded")
	# Called every time the node is added to the scene.
	# Initialization here
	#get_tree().connect("tree_changed", self, "on_tree_change")
	on_tree_change()

func on_tree_change():
	print("Loading hp_bars")
	var players = get_tree().get_nodes_in_group("has_hp_bar")
	for player in previous_players:
		if(not player in players):
			remove_player(player)
	for player in players:
		if(not player in previous_players):
			add_player(player)
	print("hp_bars loaded")

func add_player(player):
	print("Add HP bar");
	var bar = load("res://nodes/hp_bar.tscn").instance();
	bar.set_player(player)
	get_tree().get_root().call_deferred("add_child", bar)
	previous_players[player] = bar

func remove_player(player):
	print("Remove HP bar")
	var bar = previous_players[player]
	bar.get_parent().remove_child()
	previous_players.erase(player)
	bar.destroy()