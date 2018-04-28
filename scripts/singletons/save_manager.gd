extends Node

signal save_changed(value)

var save_file = {}

func load_file(path = "res://saves/test_save.json"):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	save_file = parse_json(text)

func save_current_file(path = "res://saves/test_save.json"):
	print(path)
	var file = File.new()
	file.open(path, file.WRITE)
	var json = to_json(save_file)
	print(json)
	var text = file.store_string(json)
	file.close()

func get_current_save():
	return save_file
	
func set_property(path, value):
	var path_array = path.split("/")
	var container = save_file
	
	for elem in path_array:
		if(elem == path_array[path_array.size() - 1]):
			container[elem] = value
		elif(not container.has(elem)):
			container[elem] = {}
		
		container = container[elem]
	
	emit_signal("save_changed", path)
	

func get_property(path):
	var path_array = path.split("/")
	var container = save_file
	
	for elem in path_array:
		if(not container.has(elem)):
			return null
		elif(elem == path_array[path_array.size() - 1]):
			return container[elem]
		else:
			container = container[elem]

func has_property(path):
	var path_array = path.split("/")
	var container = save_file
	
	for elem in path_array:
		if(not container.has(elem)):
			return false
		elif(elem == path_array[path_array.size() - 1]):
			return true
		else:
			container = container[elem]