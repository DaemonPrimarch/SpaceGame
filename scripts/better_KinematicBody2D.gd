extends KinematicBody2D

signal collision

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
	
	func _init(collider = null, collider_id = null, collider_metadata = null, collider_shape = null, collider_shape_index = null, collider_velocity = null, local_shape = null, normal = null, position = null, remainder = null, travel= null):
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
	
	func has_collision():
		return get_collider() != null
	
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

func _ready():
	connect("collision", self, "on_collision")

#Moves the object by an amount, returns wether it collided
func move(direction):
	.move(direction)

	var collision_info

	if(is_colliding()):
		collision_info = KinematicCollision2D.new(get_collider(), null, get_collider_metadata(), get_collider_shape(), null, get_collider_velocity(), null, get_collision_normal(), get_collision_pos(), null, get_travel())
		emit_signal("collision", collision_info)
		get_collider().emit_signal("collision", collision_info)
		
		return collision_info
	else:
		return KinematicCollision2D.new()
		
func move_no_collision(direction):
	set_pos(get_pos() + direction)

func on_collision(body):
	pass

