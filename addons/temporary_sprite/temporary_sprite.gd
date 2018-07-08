tool
extends Panel

func _ready():
	if(not has_node("NameLabel")):
		var label = Label.new()
		
		label.name = "NameLabel"
		label.text = "Name"
		
		label.align = Label.ALIGN_CENTER
			
		add_child(label)
		
		label.set_owner(get_tree().get_edited_scene_root())