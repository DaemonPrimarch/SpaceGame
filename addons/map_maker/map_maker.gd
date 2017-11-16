tool

extends EditorPlugin

var button

func _enter_tree():
	button = preload("res://addons/map_maker/button.tscn").instance()
	
	button.connect("pressed", self, "draw_map")
	
	add_control_to_container(CONTAINER_TOOLBAR, button)

func _exit_tree():
	button.free()


	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func draw_map():
	var window = preload("res://addons/map_maker/map_window.tscn").instance()
	
	add_child(window)
	
	window.popup()