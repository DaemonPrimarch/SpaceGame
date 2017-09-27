extends KinematicBody2D

signal collision

func _ready():
	connect("collision", self, "on_collision")

#Moves the object by an amount, returns wether it collided
func move(direction):
	.move(direction)

	if(is_colliding()):
		emit_signal("collision", get_collider())
		get_collider().emit_signal("collision", get_collider())
		return true
	else:
		return false
		
func move_no_collision(direction):
	set_pos(get_pos() + direction)

func on_collision(body):
	pass

class KinematicCollision2D:
	#Collision data for KinematicBody2D collisions.
	#Copied from future godot version: http://docs.godotengine.org/en/latest/classes/class_kinematiccollision2d.html#class-kinematiccollision2d
	#Read link for documentation
	
	var collider;
	var collider_id
	var collider_metadata
	var collider_shape
	var collider_shape_index
	var collider_velocity
	var local_shape
	var normal
	var position
	var remainder
	var travel
	
	func _init(collider, collider_id, collider_metadata, collider_shape, collider_shape_index, collider_velocity, local_shape, normal, position, remainder, travel):
		self.collider = collider
		self.collider_id = collider_id
		self.collider_metadata = collider_metadata
		self.collider_shape = collider_shape
		self.collider_shape_index = collider_shape_index
		self.collider_velocity = collider_velocity
		self.local_shape = local_shape
		self.normal = normal
		self.position = position
		self.remainder = remainder
		self.travel = travel
	
	func get_collider():
		return collider
	
	func get_collider_id():
		return collider_id
	
	func get_collider_metadata():
		return collider_metadata
	
	func get_collider_shape():
		return collider_shape
		
	func get_collider_shape_index():
		return collider_shape_index
	
	func get_collider_velocity():
		return collider_velocity
	
	func get_local_shape():
		return local_shape
	
	func get_normal():
		return normal
	
	func get_relainder():
		return remainder
		
	func get_travel():
		return travel