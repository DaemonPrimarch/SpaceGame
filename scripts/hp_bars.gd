extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var current_players = {}
var canvas_layer

func _ready():
	print("PREPARING")
	get_tree().connect("tree_changed", self, "on_tree_change")
	canvas_layer = CanvasLayer.new()
	get_tree().get_root().call_deferred("add_child", canvas_layer)
	on_tree_change()

func on_tree_change():
	if(is_inside_tree()):
		var players = get_tree().get_nodes_in_group("has_hp_bar")

		for player in current_players:
			if(not player in players):
				remove_player(player)
		
		for player in players:
			if(not player in current_players):
				add_player(player)
		
		var i = 0
		for player in current_players:
			current_players[player].set_pos(Vector2(current_players[player].get_pos().x, current_players[player].get_size().y *i))
			i+=1


func add_player(player):
	print("added", current_players.size())
	var bar = load("res://nodes/hp_bar.tscn").instance();
	bar.set_name(player.get_name() + "_HP_bar")
	#Temporary solution
	bar.set_player(player)
	canvas_layer.call_deferred("add_child", bar)
	current_players[player] = bar

func remove_player(player):
	var bar = current_players[player]
	current_players.erase(player)
	bar.destroy()