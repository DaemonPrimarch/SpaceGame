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
		place_player_in_background(play)
		player = play
	
func place_player_in_background(player):
	old_player_background_mask = player.mask
	old_platform_background_layer = player.layer
	
	player.mask = player_background_mask
	player.layer = player_background_layer
	
func place_platform_in_background():
	old_platform_background_layer = get_platform().layer
	old_platform_background_mask = get_platform().mask
	
	get_platform().mask = platform_background_mask
	get_platform().layer = platform_background_layer

func place_platform_in_foreground():
	get_platform().mask = old_platform_background_mask
	get_platform().layer = old_platform_background_layer

func place_player_in_foreground(player):
	player.mask = old_player_background_mask
	player.layer = old_platform_background_layer

func _on_elevator_system_arrived_at_next_point(point):
	if(started):
		place_player_in_background(player)
		started = false
