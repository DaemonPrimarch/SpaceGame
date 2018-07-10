tool

extends AnimationPlayer

signal cutscene_started
signal cutscene_finished
signal cutscene_paused

export(String, FILE, "*.json") var dialog_tree
export var paused = false setget set_paused

var paused_position


func _ready():
	pass
	
func _physics_process(delta):
	clear_caches()

func start_dialog_tree():
	get_node("/root/DIALOG_SYSTEM").queue_tree_from_json(dialog_tree)
	
func advance_dialog_tree():
	get_node("/root/DIALOG_SYSTEM").advance_current_tree()
	
func start_cutscene():
	play("cutscene")
	
#	if(not Engine.editor_hint):
#		get_node("/root/DIALOG_SYSTEM").connect("options_shown", self, "on_dialog_options_shown")
	
	emit_signal("cutscene_started")

func on_dialog_options_shown():
	#UNUSED
	set_paused(true)
	
	get_node("/root/DIALOG_SYSTEM").disconnect("options_shown", self, "on_dialog_options_shown")
	get_node("/root/DIALOG_SYSTEM").connect("option_selected", self, "on_dialog_option_selected")

func on_dialog_option_selected(option):
	#UNUSED
	set_paused(false)
	
	get_node("/root/DIALOG_SYSTEM").disconnect("option_selected", self, "on_dialog_option_selected")

func set_paused(val):
	if(val != paused):
		if(val):
			print("PAUSED")
			paused_position = current_animation_position
			stop(false)
		else:
			if(not Engine.editor_hint):
				current_animation = "cutscene"
				seek(paused_position )
	
	paused = val

func is_paused():
	return paused

func _on_cutscene_player_animation_finished(anim_name):
	if(not is_paused()):
		emit_signal("cutscene_finished")
