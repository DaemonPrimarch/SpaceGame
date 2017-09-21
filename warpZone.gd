extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var destinationScene = "test"
export var destinationCoordinates = Vector2(0,0)


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("area_enter", self, "_on_Area2D_area_enter") 
	#connect("body_enter", self, "_on_Area2D_area_enter") 
	print("Gello World")



func body_enter( node ):
	print("Hello World?")
	var new_scene = load(destinationScene).instance()
	node.get_parent().remove_child(node)
	new_scene.add_child(node)


func _on_Area2D_body_enter( body ):
	var new_scene = load(destinationScene).instance()
	#body.get_parent().remove_child(body)
	body.get_tree().get_root().add_child(new_scene)
	new_scene.set_pos(destinationCoordinates)
	print("Hello JJJ??")


func _on_Area2D_area_enter( area ):
	print("Hello vvv??")
