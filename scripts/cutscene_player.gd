tool

extends AnimationPlayer

signal cutscene_finished
signal cutscene_paused

export(String, FILE, "*.json") var dialog_tree
export var paused = false setget set_paused

var dialog_system
var camera
var player

var paused_position


func _ready():
	dialog_system = get_node("/root/DIALOG_SYSTEM")
	camera = get_node("/root/CAMERA_MANAGER").get_active_camera()
	
func _physics_process(delta):
	clear_caches()

func play_dialog_tree():
	print("Q")
	get_node("/root/DIALOG_SYSTEM").queue_tree_from_json(dialog_tree)
	
func play_cutscene():
	print("PLA")
	play("cutscene")

func set_paused(val):
	if(val != paused):
		if(val):
			print("PAUSED")
			paused_position = current_animation_position
			#stop(false)
		else:
			if(not Engine.editor_hint):
				current_animation = "cutscene"
				#seek(paused_position )
	
	paused = val