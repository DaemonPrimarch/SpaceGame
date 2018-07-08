tool
extends Panel

func _ready():
	if(not has_node("NameLabel")):
		var label = Label.new()
		
		label.name = "NameLabel"
		label.text = "Name"
		
		label.rect_position = Vector2(2, 24)
		
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		
		add_child(label)
		
		label.set_owner(get_tree().get_edited_scene_root())