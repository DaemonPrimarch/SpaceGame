tool
extends Panel

export var auto_resize = true

func _ready():
	if(not has_node("NameLabel")):
		var label = Label.new()
		
		label.name = "NameLabel"
		label.text = "Name"
		
		label.rect_position = Vector2(2, 64)
		
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		
		add_child(label)
		
		label.set_owner(get_tree().get_edited_scene_root())
		
	if(auto_resize and get_parent() and get_parent().has_method("get_AABB")):
		get_parent().connect("AABB_changed", self, "auto_resize")

func auto_resize():
	rect_position = get_parent().to_local(get_parent().get_AABB().position)
	rect_size = get_parent().get_AABB().size
