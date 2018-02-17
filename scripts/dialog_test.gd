extends "res://scripts/bullet_switch.gd"

export(String, FILE, "*.json") var dialog 

func _on_bullet_switch_switched_on():
	
	var file = File.new()
	file.open(dialog, file.READ)
	var text = file.get_as_text()
	
	DIALOG_SYSTEM.queue_tree(parse_json(text))
	file.close()
	print("DONE")
