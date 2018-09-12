tool

extends Node2D

signal player_entered(player)
signal room_lit()
signal room_darkened()

export var dark = false setget set_dark, is_dark 
export var dark_color = Color(0,0,0)
export var auto_generate_camera_limiter = true

var default_screen_size = Vector2(1664, 960)

func _draw():
	if(Engine.editor_hint):
		for i in range(-30, 30):
			draw_line(Vector2(i * default_screen_size.x, -30 * default_screen_size.y), Vector2(i * default_screen_size.x, 15 * default_screen_size.y), Color(0,1,0,0.5), 1)
			draw_line(Vector2(-30 * default_screen_size.x, i * default_screen_size.y), Vector2(30 * default_screen_size.x, i * default_screen_size.y), Color(0,1,0,0.5), 1)
func _ready():	
	if(Engine.editor_hint and not has_node("terrain")):
		var ter = preload("res://nodes/terrain.tscn").instance()
		
		add_child(ter)
		
		ter.set_owner(get_tree().get_edited_scene_root())
		
	if(Engine.editor_hint and not has_node("player")):
		var play = preload("res://nodes/entities/player/puppet_player.tscn").instance()
		
		add_child(play)
		
		play.set_owner(get_tree().get_edited_scene_root())
	
	if(Engine.editor_hint and not has_node("CanvasModulate")):
		var mod = CanvasModulate.new()
		add_child(mod)
		
		mod.set_owner(get_tree().get_edited_scene_root())
		
		mod.color = Color(1,1,1,1)
		
		mod.set_meta("_edit_lock_", true)
	
	if(Engine.editor_hint and auto_generate_camera_limiter):
		generate_camera_limiter()
		
	add_to_group("room")
	
	connect("player_entered", self, "_on_room_player_entered")
	connect("room_darkened", self, "_on_room_room_darkened")
	connect("room_lit", self, "_on_room_room_lit")
	
	_iterate_over_children(self)

func _iterate_over_children(node):
	if(node.is_in_group("entity")):
		node.emit_signal("room_entered")
	
	for child in node.get_children():
		_iterate_over_children(child)
		
func _physics_process(delta):
	pass

func set_dark(val):
	dark = val
	
	if(not val):
		call_deferred("emit_signal","room_lit")
	else:
		call_deferred("emit_signal","room_darkened")

func is_dark():
	return dark

func _on_room_room_darkened():
	get_node("CanvasModulate").color = dark_color
	if(is_inside_tree()):
		for light in get_tree().get_nodes_in_group("darkness_detecting_light"):
			if(not light.enabled):
				light.enabled = true

func _on_room_room_lit():
	get_node("CanvasModulate").color = Color(1,1,1)
	if(is_inside_tree()):
		for light in get_tree().get_nodes_in_group("darkness_detecting_light"):
			if(light.enabled):
				light.enabled = false

func generate_camera_limiter():
	var min_point = Vector2(10000, 10000)
	
	for tile in get_node("terrain").get_used_cells():
		if(tile.x < min_point.x):
			min_point = tile
		
	var rect = Rect2();
	for node in get_tree().get_nodes_in_group("terrain"):
		if(rect.has_no_area()):
			rect = node.get_AABB();
		else:
			rect = rect.merge(node.get_AABB());
	
	var scrolling_point = min_point
	var polygon = []
	
	if(not rect.has_no_area()):
		polygon.push_back(to_local(rect.position))
		polygon.push_back((to_local(rect.position) + rect.size * Vector2(0, 1)))
		polygon.push_back((to_local(rect.position) + rect.size))
		polygon.push_back((to_local(rect.position) + rect.size * Vector2(1, 0)))
		
		var collision_polygon
		
		if(not has_node("AutoGeneratedCameraLimitArea") and not has_node("AutoGeneratedCameraLimitRect")):
			var limit_rect = preload("res://addons/extended_camera_2D/camera_limit_rect.gd").new()
				
			limit_rect.visible = false

			limit_rect.name = "AutoGeneratedCameraLimitRect"
			
			add_child(limit_rect)
	
			limit_rect.set_owner(get_tree().get_edited_scene_root())
	
		if(has_node("AutoGeneratedCameraLimitArea")):
			collision_polygon = get_node("AutoGeneratedCameraLimitArea").get_node("CollisionPolygon2D")
		if(has_node("AutoGeneratedCameraLimitRect")):
			collision_polygon = get_node("AutoGeneratedCameraLimitRect")
			
		collision_polygon.set_polygon(polygon)

func _on_room_player_entered(player):
	get_node("/root/GUI").set_room_name(get_node("/root/ROOM_MANAGER").get_path_of_room(self))
