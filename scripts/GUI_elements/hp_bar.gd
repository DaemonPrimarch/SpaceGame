extends ProgressBar

var tracked_object = null

func _ready():
	set_min(0);

func get_tracked_object():
	return tracked_object

func set_tracked_object(object):
	set_name(object.get_name() + "_HP_bar")
	get_node("object_nametag").set_text(object.get_name())
	object.connect("HP_changed", self, "hp_changed")
	object.connect("tree_exited", self, "remove_tracked_object")

	tracked_object = object
	set_max(object.get_max_HP())
	set_value(object.get_HP())
	set_step(1)
	get_node("health").text = String(object.get_HP())
	update()

func remove_tracked_object():
	GUI.HP_bar_helper.remove_HP_bar(get_tracked_object())

func hp_changed():
	set_value(get_tracked_object().get_HP())
	get_node("health").text = String(get_tracked_object().get_HP())
	
	$ExtendedAnimationPlayer.play("changed")
	
	update()

func destroy():
	queue_free()