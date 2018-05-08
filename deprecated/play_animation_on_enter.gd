extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var done = false

func _ready():
	if(SAVE_MANAGER.has_property("to_engine/room6/entet_cutscene_trigger")):
		done = SAVE_MANAGER.get_property("to_engine/room6/entet_cutscene_trigger")

func play_animation():
	get_node("AnimationPlayer").play("main")
	print("ZUM")

func _on_play_animation_on_enter_body_entered(body):
	if(body.is_in_group("player") and not done):
		play_animation()
		done = true
		SAVE_MANAGER.set_property("to_engine/room6/entet_cutscene_trigger", true)

func camera_zoom_out_to(val, time):
	print("ZOOMING")
	get_node("/root/CAMERA_MANAGER").get_active_camera().zoom_to(val, time)