extends Position2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func on_player_enter(player):
	print(player.get_name(), " entered.")

func _on_player_enter(player):
	print(player.get_name(), " entered.")
