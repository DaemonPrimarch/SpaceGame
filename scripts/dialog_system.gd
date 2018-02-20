extends Node

var dialog_queue = []
var box
var displaying = false

var current_tree
var current_element

func _ready():
	box = get_node("/root/GUI").get_layer().get_node("dialog_box")
	
	box.connect("pressed_continue", self, "box_finished_printing")
	box.connect("option_selected", self, "box_option_selected")
	
	get_box().set_displaying(false)
	displaying = false

func queue_tree_from_json(path):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	queue_tree(parse_json(text))

func get_current_dialog_element():
	return current_element

func get_current_dialog_tree():
	return current_tree

func set_current_dialog_element(element):
	current_element = element
	
	if(element.has("name")):
		get_box().set_using_name(true)
		get_box().set_speaker_name(element.name)
	else:
		get_box().set_using_name(false)
		
	get_box().set_text(element.text)
	
	if(element.has("options")):
		get_box().set_using_options(true)
		get_box().set_options(element.options)
	else:
		get_box().set_using_options(false)

func set_current_dialog_tree(tree):
	current_tree = tree
	
	set_current_dialog_element(tree.start)

func load_next_tree():
	print("Loaded")
	
	if(not dialog_queue.empty()):
		displaying = true
		get_box().set_displaying(true)
		
		var next_tree = dialog_queue.pop_back()
		
		set_current_dialog_tree(next_tree)
		
		display_current_element()
	else:
		get_box().set_displaying(false)
		displaying = false

func get_box():
	return box

func queue_tree(tree):
	dialog_queue.push_back(tree)
	
	if(not displaying):
		load_next_tree()
	
func queue_message(message):
	queue_tree({"start": {"text": message}})

func box_finished_printing():
	if(get_current_dialog_element().has("options")):
		pass
	elif(get_current_dialog_element().has("next")):
		set_current_dialog_element(get_current_dialog_tree()[get_current_dialog_element().next])
		display_current_element()
	else:
		load_next_tree()
		
func box_option_selected(option):	
	set_current_dialog_element(get_current_dialog_tree()[get_current_dialog_element().next[get_current_dialog_element().options.find(option)]])
	display_current_element()
	
func display_current_element():
	get_box().start_dialog()
	