extends Node

var dialog_queue = []
var box
var displaying = false

var current_tree
var current_element

func _ready():
	box = get_node("/root/GUI").get_layer().get_node("dialog_box")
	
	box.connect("text_finished_scrolling", self, "box_finished_printing")
	box.connect("pressed_continue", self, "box_pressed_continue")
	box.connect("option_selected", self, "box_option_selected")
	
	get_box().set_displaying(false)
	displaying = false

func hide_dialog_box():
	get_box().visible = false

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
	get_box().visible = true
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
		
	if(element.has("scroll_speed")):
		get_box().set_text_scroll_speed(element.scroll_speed)
	else:
		get_box().set_text_scroll_speed(get_box().default_scroll_speed)

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

func advance_current_tree():
	print("ADVANCED")
	if(get_current_dialog_element().has("options")):
		pass
	elif(get_current_dialog_element().has("next")):
		set_current_dialog_element(get_current_dialog_tree()[get_current_dialog_element().next])
		display_current_element()
	else:
		load_next_tree()

func get_box():
	return box

func queue_tree(tree):
	dialog_queue.push_back(tree)
	
	if(not displaying):
		load_next_tree()
	
func queue_message(message):
	queue_tree({"start": {"text": message, "auto_advance": true}})

func box_pressed_continue():
	advance_current_tree()

func box_finished_printing():
	if(get_current_dialog_element().has("auto_advance")):
		if(get_current_dialog_element().auto_advance):
			advance_current_tree()
		else:
			pass
	elif(get_current_dialog_element().has("next_indicator")):
		if(get_current_dialog_element().next_indicator):
			box.set_next_indicator_enabled(true)
		
func box_option_selected(option):	
	set_current_dialog_element(get_current_dialog_tree()[get_current_dialog_element().next[get_current_dialog_element().options.find(option)]])
	display_current_element()
	
func display_current_element():
	get_box().start_dialog()
	