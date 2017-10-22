extends Node

var regular_box
var selection_box

var current_element

var finished = false
var playing = false

var dialog_queue = []

func _ready():
	call_deferred("setup")

func create_linear_tree(array):
	var previous
	
	for i in range(array.size() - 1, -1, -1):
		var new
		if(typeof(array[i]) == TYPE_STRING):
			new = LinearTextElement.new(array[i])
		else:
			new = array[i]
		
		if(i != array.size() - 1):
			new.set_next(previous)
			
		previous = new
	
	return previous

func on_option_selected(option):
	get_current_element().set_selected_option(option)
	
	selection_box.disconnect("option_selected", self, "on_option_selected")
	
	selection_box.hide()
	regular_box.hide()
	
	advance_tree()
	
func on_finished_displaying():
	regular_box.disconnect("finished_displaying", self, "on_finished_displaying")
	
	regular_box.hide()
	
	advance_tree()

func is_playing():
	return playing

func setup():
	regular_box = GUI.get_layer().get_node("dialog_box")
	selection_box = GUI.get_layer().get_node("option_select_box")
	selection_box.hide()
	regular_box.hide()
	var first_of_first = create_linear_tree(["Everything dies,"])
	var right = create_linear_tree(["That is correct!"])
	var wrong = create_linear_tree(["That is incorrect!", "Choose again!", first_of_first])
	var choice = ChoiceElement.new("Do you accept it?", ["Yes", "No"])
	var branch = BranchElement.new(choice, "Yes", right, wrong)
	var first = create_linear_tree([first_of_first, "It is inevitable,", choice, branch])
	play_dialog(first)

func play_dialog(dialog):
	if(is_playing()):
		dialog_queue.push_back(dialog)
	else:
		set_current_element(dialog)
		playing = true
		display_current_element()

func get_current_element():
	return current_element

func set_current_element(element):
	current_element = element

func advance_tree():
	if(not get_current_element().is_last()):
		set_current_element(get_current_element().get_next())
		
		display_current_element()
	else:
		if(dialog_queue.size() > 0):
			set_current_element(dialog_queue[0])
			dialog_queue.pop_front()
			display_current_element()
		else:
			playing = false
func display_current_element():
	regular_box.show()
	regular_box.set_total_text(get_current_element().get_text())
	regular_box.scrolling = true
	
	if(get_current_element().is_choice_element()):
		selection_box.set_options(get_current_element().get_options())
		selection_box.display()
		selection_box.show()
		selection_box.connect("option_selected", self, "on_option_selected")
	else:
		regular_box.connect("finished_displaying", self, "on_finished_displaying")
		
	regular_box.display()

class DialogElement:
	var option
	var next
	
	func is_choice_element():
		return false
	
	func get_selected_option():
		return option
	func set_selected_option(option):
		self.option = option
	
	func get_options():
		return []
			
	func get_text():
		return "Hello world"
	
	func set_next(next):
		self.next = next
	
	func get_next():
		return null
		
	func is_last():
		return false

class LinearTextElement extends DialogElement:
	var text
	
	func _init(text, next = null):
		self.text = text
		self.next = next
	func get_text():
		return self.text
	func get_next():
		return self.next
	func is_last():
		return self.next == null
		
class BranchElement extends DialogElement:
	var linked_obj
	var right_choice
	var right_branch
	var wrong_branch
	func _init(linked_obj, right_choice, right_branch, wrong_branch):
		self.linked_obj = linked_obj
		self.right_choice = right_choice
		self.right_branch = right_branch
		self.wrong_branch = wrong_branch
	
	func get_text():
		return ""
	func is_last():
		return false
	func get_next():
		if(linked_obj.get_selected_option() == right_choice):
			return right_branch
		else:
			return wrong_branch

class ChoiceElement extends DialogElement:
	var text
	var options
	
	func _init(text, options, next = null):
		self.text = text
		self.next = next
		self.options = options
	func is_choice_element():
		return true
	func get_text():
		return self.text
	func get_options():
		return self.options	
	func get_next():
		return self.next
	func is_last():
		return self.next == null