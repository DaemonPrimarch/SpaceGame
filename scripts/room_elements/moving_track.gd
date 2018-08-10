tool
extends StaticBody2D

signal direction_changed()
signal node_connected(node)
signal node_disconnected(node)

export var moving_forward = true setget set_moving_forward
export var speed = 64 setget set_speed
export(int, 64, 640000, 64)  var length = 64 setget set_length
export var fast = false
export var fast_camera_offset = Vector2()
export var applies_fast_camera_offset = false

func is_fast():
	return fast

func get_fast_camera_offset():
	var dir = Vector2(1, 0)
	
	if(not is_moving_forward()):
		dir = Vector2(-1, 0)
	
	return fast_camera_offset * dir

func _ready():
	set_length(length)
	add_to_group("track")
	
	set_physics_process(not Engine.editor_hint)

func set_speed(p_speed):
	speed = p_speed

func get_speed():
	return speed

func set_moving_forward(val):
	var prev_val = moving_forward
	
	moving_forward = val
	
	if(prev_val != moving_forward):
		emit_signal("direction_changed")

func is_moving_forward():
	return moving_forward

func set_length(p_length):
	length = p_length
	
	if(is_inside_tree()):
		$sprites/back.position.x = length - 64
		
		$sprites/middle.position.x = length/2 - 32
		$sprites/middle.region_rect.size.x = max(length - 64 * 2, 0)
		
		$Area2D/CollisionPolygon2D.polygon[2].x = length - 32
		$Area2D/CollisionPolygon2D.polygon[3].x = length - 32
		
		$CollisionPolygon2D.polygon[2].x = length - 32
		$CollisionPolygon2D.polygon[3].x = length - 32


var time_track = 0

func _physics_process(delta):
	for node in $Area2D.get_overlapping_bodies():
		if(not is_node_connected(node) and node.is_in_group("handles_track") and node.is_grounded()):
			connect_node(node)
		
	for node in connected_nodes:
		if(not time_track >= 1 and (not $Area2D.overlaps_body(node) or not node.is_grounded())):
			disconnect_node(node)
	
	if(not is_fast()):
		for node in $Area2D.get_overlapping_bodies():
			pass
	
	if(time_track >= 2):
		time_track = 0
	if(time_track >= 1):
		time_track += 1
	

var connected_nodes = []

func is_node_connected(node):
	return connected_nodes.find(node) != -1

func connect_node(node):	
	time_track = 1
	
	connected_nodes.push_back(node)
	
	node.get_node("track_manager").set_track(self)

func disconnect_node(node):
	connected_nodes.remove(connected_nodes.find(node))
	
	node.get_node("track_manager").remove_track(self)
#
#func body_ground_entered(body):
#	body.track_manager.set_track(self)
#
#	if(body.is_connected("ground_entered", self, "body_ground_entered")):
#		body.disconnect("ground_entered", self, "body_ground_entered")
#	body.connect("ground_exited", self, "body_ground_exited", [body])
#
#func body_ground_exited(body):
#	body.track_manager.set_track(null)
#
#	if(body.is_connected("ground_exited", self, "body_ground_exited")):
#		body.disconnect("ground_exited", self, "body_ground_exited")
#
#func _on_Area2D_body_entered(body):
#	if(body.is_in_group("handles_track")):
#		if(body.is_grounded()):
#			body_ground_entered(body)
#		else:
#			body.connect("ground_entered", self, "body_ground_entered", [body])
#
#func _on_Area2D_body_exited(body):
#	if(body.is_in_group("handles_track") and body.track_manager.is_on_track()):
#		body_ground_exited(body)
