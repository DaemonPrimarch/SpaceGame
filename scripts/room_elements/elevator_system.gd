extends "res://scripts/room_elements/platform_mover.gd"

export var in_back_ground = false

export(int, FLAGS) var player_background_layer
export(int, FLAGS) var player_background_mask
export(int, FLAGS) var platform_background_layer
export(int, FLAGS) var platform_background_mask

var old_player_background_layer
var old_player_background_mask
var old_platform_background_layer
var old_platform_background_mask

var started = false

var player

func _on_point_0_notifier_screen_entered():
	if(not is_moving()):
		get_platform().position  = $point_0.position
		
		set_next_point($point_1.position)
		set_previous_point($point_0.position)

func _on_point_1_notifier_screen_entered():
	if(not is_moving()):
		get_platform().position  = $point_1.position
		
		set_next_point($point_0.position)
		set_previous_point($point_1.position)

func start_elevator():
	started = true
	
	set_active(true)
	
	for play in get_platform().connected_nodes:
		print("PLACED IN BACKGROUND 2")
		if(play.is_in_group("layer_changeable")):
			play.get_node("layer_changer").set_in_background(true)
			print("PLACED IN BACKGROUND")
		player = play
	
func place_player_in_background(player):
	old_player_background_mask = player.collision_mask
	old_platform_background_layer = player.collision_layer
	
	player.collision_mask = player_background_mask
	player.collision_layer = player_background_layer
	
func place_platform_in_background():
	old_platform_background_layer = get_platform().collision_layer
	old_platform_background_mask = get_platform().collision_mask
	
	get_platform().collision_mask = platform_background_mask
	get_platform().collision_layer = platform_background_layer
	get_platform().get_node("standing_area").collision_mask = platform_background_mask
	get_platform().get_node("standing_area").collision_layer = platform_background_layer

func place_platform_in_foreground():
	get_platform().collision_mask = old_platform_background_mask
	get_platform().collision_layer = old_platform_background_layer
	
	get_platform().get_node("standing_area").collision_mask = old_platform_background_mask
	get_platform().get_node("standing_area").collision_layer = old_platform_background_layer

func place_player_in_foreground(player):
	player.collision_mask = old_player_background_mask
	player.collision_layer = old_platform_background_layer

func _on_elevator_system_arrived_at_next_point(point):
	if(started):
		place_player_in_background(player)
		started = false
