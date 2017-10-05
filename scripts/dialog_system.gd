extends Node

var regular_box
var selection_box

var current_element

var finished = false

func _ready():
	regular_box = preload("res://nodes/dialog_box.tscn").instance()

	selection_box = preload("res://nodes/option_select_box.tscn").instance()
	selection_box.hide()
	regular_box.hide()
	call_deferred("setup")

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

func setup():
	GUI.get_layer().add_child(regular_box)
	regular_box.set_pos(Vector2(0,600))
	GUI.get_layer().add_child(selection_box)
	selection_box.set_pos(Vector2(400,600))
	var C = ChoiceElement.new("Question?:", ["A", "B", "C", "D", "E", "F", "G"])
	var D = ExtraRegularTextElement.new(C)
	C.set_next(D)
	var B = RegularTextElement.new("Hello world!!!!!!!", C)
	var A = RegularTextElement.new("Hello world???????", B) 
	
	set_current_element(A)
	
	display_current_element()

func start_tree(tree):
	set_current_element(tree)

func get_current_element():
	return current_element

func set_current_element(element):
	current_element = element

func advance_tree():
	if(not get_current_element().is_last()):	
		set_current_element(get_current_element().get_next())
		
		display_current_element()
		

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
	
func clear(empt = null):
	selection_box.hide()
	regular_box.hide()

class DialogElement:
	var option
	
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

class RegularTextElement extends DialogElement:
	var text
	var next
	
	func _init(text, next = null):
		self.text = text
		self.next = next
	func get_text():
		return self.text
	func get_next():
		return self.next
	func is_last():
		return self.next == null
	
class ExtraRegularTextElement extends DialogElement:
	var next
	var linked_obj
	func _init(linked_obj, next = null):
		self.linked_obj = linked_obj
		self.next = next
	func get_text():
		return "Option chosen: " + linked_obj.get_selected_option() + " yeah that is correct!"
	func get_next():
		return self.next
	func is_last():
		return self.next == null
class ChoiceElement extends DialogElement:
	var text
	var next
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