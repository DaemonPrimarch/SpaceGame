tool

extends AnimationPlayer

export(String, FILE, "*.json") var dialog_tree

var dialog_system
var camera
var player

func _ready():
	dialog_system = get_node("/root/DIALOG_SYSTEM")
	camera = get_node("/root/CAMERA_MANAGER").get_active_camera()

func play_dialog_tree():
	print("Q")
	get_node("/root/DIALOG_SYSTEM").queue_tree_from_json(dialog_tree)
	
func play_cutscene():
	print("PLA")
	play("cutscene")