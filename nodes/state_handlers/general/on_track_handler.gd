extends "res://addons/state_handler/state_handler.gd"

var track_manager = null
var track = null

export var camera_offset_time = 1

func _ready():
	get_parent().get_node("track_manager").connect("track_changed", self, "init_track")

func init_track():
	track_manager = get_parent().track_manager
	track = track_manager.get_track()
	
	track_direction_changed()
	
	track.connect("direction_changed", self, "track_direction_changed")
	
	get_parent().set_velocity(Vector2(track.get_speed(), 0)) 
#
#	if(track.applies_fast_camera_offset):
#		#get_parent().get_node("ExtendedCamera2D").anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
#		get_parent().get_node("ExtendedCamera2D").move_at_speed_to(track.get_fast_camera_offset(), camera_offset_time, true)
	
func enter_state(previous_state):	
	get_parent().animation_player.stop()
	
	init_track()	

func leave_state(new_state):	
	track.disconnect("direction_changed", self, "track_direction_changed")

func track_direction_changed():	
	get_parent().set_flippedH(not track.is_moving_forward())

func process_state(delta):
	get_parent().animation_player.play("duck")
	if(not track_manager.is_on_track()):
		if(not get_parent().is_grounded() and track.is_fast()):
			get_parent().set_state("TRACK_FALLING")
		else:
			get_parent().set_state("STANDING")
	elif(get_parent().is_action_just_pressed("jump")):
		get_parent().set_state("TRACK_JUMPING")