extends Control

signal option_selected

var options = {}
var ordered_options = []
var displaying = false
var highlighted_item_index = 0

onready var cursor = get_node("cursor")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("option_selected",self, "printO")
	
func printO(opt):
	print("Option selected: ", opt)

func set_options(options):
	ordered_options = options
	self.options.clear()
	for option in options:
		self.options[option] = null

func get_options():
	return options
	
func hide():
	.hide()
	set_process_input(false)
	
func show():
	.show()
	set_process_input(true)

func display():
	var i = 0
	for option in ordered_options:
		var selectable = Label.new()
		
		add_child(selectable)
		selectable.set_pos(Vector2(0, i * selectable.get_size().y))
		selectable.set_text(option)
		selectable.set_name("Selection: " + option)
		options[option] = selectable
		
		i+= 1
		
func move_cursor_to(index):
	index %= options.size()
	
	cursor.get_parent().remove_child(cursor)
	get_options()[ordered_options[index]].add_child(cursor)
	highlighted_item_index = index

func _input( ev ):
	if(ev.is_action_pressed("ui_up")):
		move_cursor_to(highlighted_item_index - 1)
	if(ev.is_action_pressed("ui_down")):
		move_cursor_to(highlighted_item_index + 1)
	if(ev.is_action_pressed("ui_accept")):
		emit_signal("option_selected", ordered_options[highlighted_item_index])
		

	
