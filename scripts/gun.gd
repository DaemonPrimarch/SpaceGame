extends "res://scripts/weapon.gd"

export var flashlight_enabled = false

func _ready():
	get_parent().get_parent().connect("room_entered",self,"on_room_entered")


func press_trigger():
	var bullet = preload("res://nodes/weapons/bullet.tscn").instance()
	
	var room = ROOM_MANAGER.get_room_of_node(self)
	
	bullet.set_position(room.to_local(to_global(Vector2(20, 0))))
	
	bullet.set_velocity(bullet.get_velocity())
	if(PHYSICS_HELPER.get_global_scale_of_node(self).x <0):
		bullet.set_rotation(PI - rotation)
	else:
		bullet.set_rotation(rotation)
	
	room.add_child(bullet)


	#HAX https://github.com/godotengine/godot/issues/17405
var old_mask
var old_layer

func on_room_entered():
	if(ROOM_MANAGER.get_room_of_node(self).is_dark()and flashlight_enabled):
		get_node("flashlight").get_node("Light").enabled = true
		get_node("flashlight/light_area").monitoring = true
		get_node("flashlight/light_area").monitorable = true
		
		if(old_mask):
			get_node("flashlight/light_area").collision_mask = old_mask
		if(old_layer):
			get_node("flashlight/light_area").collision_layer = old_layer
		
	else:
		get_node("flashlight").get_node("Light").enabled = false
		get_node("flashlight/light_area").monitoring = false
		get_node("flashlight/light_area").monitorable = false
		
		old_mask = get_node("flashlight/light_area").collision_mask
		old_layer = get_node("flashlight/light_area").collision_layer
		
		get_node("flashlight/light_area").collision_mask = 0
		get_node("flashlight/light_area").collision_layer = 0