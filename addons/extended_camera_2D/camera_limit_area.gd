tool
extends Area2D.

export var simple = true

func _ready():
	connect("body_entered", self, "entered")
	connect("body_exited", self, "exited")
	
	if(not has_node("CollisionPolygon2D")):
		var collision_polygon = CollisionPolygon2D.new()
		
		collision_polygon.name = "CollisionPolygon2D"
		
		collision_polygon.polygon = PoolVector2Array([Vector2(), Vector2(1,0), Vector2(0,1)])
		
		collision_polygon.set_owner(get_parent()) 
		add_child(collision_polygon)
		
		print("ADDED child")

func entered(thing):
	if(thing.is_in_group("carries_camera")):
		thing.set_limit_area(self)

func exited(thing):
	if(thing.is_in_group("carries_camera")):
		if(thing.get_limit_area() == self):
			thing.set_limit_area(null)

func is_simple():
	return simple
