extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization hered
	pass

func _on_triggered():
	dialog_system.play_dialog(dialog_system.create_linear_tree(["Well, I've changed my mind", "I'm letting go.", "Because now I believe in expansion.", "I believe we endure", "Don't you see?", "Everything lives!"]))
