extends Node2D

onready var goo1 = get_node("goo1")
onready var goo2 = get_node("goo2")
onready var switch_sprite = get_node("switch")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_prompt_trigger_triggered():
	switch_sprite.set_modulate()
