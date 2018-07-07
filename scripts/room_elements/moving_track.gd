tool
extends StaticBody2D

signal direction_changed()

export var moving_forward = true setget set_moving_forward
export var speed = 64 setget set_speed
export(int, 64, 640000, 64)  var length = 64 setget set_length

func _ready():
	set_length(length)

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

func _physics_process(delta):
	for node in $Area2D.get_overlapping_bodies():
		pass

func body_ground_entered(body):
	body.track_manager.set_track(self)
	
	if(body.is_connected("ground_entered", self, "body_ground_entered")):
		body.disconnect("ground_entered", self, "body_ground_entered")
	body.connect("ground_exited", self, "body_ground_exited", [body])
	
func body_ground_exited(body):
	body.track_manager.set_track(null)
	
	if(body.is_connected("ground_exited", self, "body_ground_exited")):
		body.disconnect("ground_exited", self, "body_ground_exited")

func _on_Area2D_body_entered(body):
	if(body.is_in_group("handles_track")):
		if(body.is_grounded()):
			body_ground_entered(body)
		else:
			body.connect("ground_entered", self, "body_ground_entered", [body])
		
func _on_Area2D_body_exited(body):
	if(body.is_in_group("handles_track") and body.track_manager.is_on_track()):
		body_ground_exited(body)
