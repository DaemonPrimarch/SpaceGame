tool
extends Control

var default_scroll_speed = 10

var options = []
var option_nodes = [null, null, null, null]
var using_otions = false
var using_name = false
var selected_option_index = 0
var options_active = false
var finished = false
var displaying  = true

signal text_finished_scrolling
signal pressed_continue
signal option_selected(option)

func _ready():
	set_text_scroll_speed(default_scroll_speed)

func _input(event):
	if(is_displaying()):
		if(options_active):
			if(event.is_action_pressed("ui_up")):
				option_nodes[selected_option_index].deselect()
				selected_option_index = (selected_option_index - 1 + options.size()) % options.size()
				option_nodes[selected_option_index].select()
				
			elif(event.is_action_pressed("ui_down")):
				option_nodes[selected_option_index].deselect()
				selected_option_index = (selected_option_index + 1 + options.size()) % options.size()
				option_nodes[selected_option_index].select()
			elif(event.is_action_pressed("ui_accept")):
				set_options_active(false)
				
				emit_signal("option_selected", options[selected_option_index])
		elif(is_next_indicator_enabled()):
			if(event.is_action_pressed("ui_accept")):
				emit_signal("pressed_continue")
				print("PRRRRRRRRR")

func set_using_options(val):
	using_otions = val

func is_next_indicator_enabled():
	return get_node("box/next_indicator").visible
	
func is_using_options():
	return using_otions

func set_displaying(val):
	displaying = val
	
	self.visible = val
	
func set_next_indicator_enabled(val):
	get_node("box/next_indicator").visible = val

func is_displaying():
	return displaying

func set_text_scroll_speed(speed):
	get_node("scroll_timer").wait_time = (1.0/speed)

func set_speaker_name(name):
	get_node("box/name_box").text = name

func set_text(text):
	get_node("box/text_box").text = text
	get_node("box/text_box").visible_characters = 0

func set_options_active(val):
	options_active = val
	
	get_node("selection_boxes").visible = val
	
func set_using_name(val):
	get_node("box/name_box").visible = val

func start_dialog():
	finished = false
	get_node("box/next_indicator").visible = false
	
	get_node("scroll_timer").start()
	
func set_options(array):
	options = array
	
	get_node("selection_boxes/selection_box_2").visible = false
	get_node("selection_boxes/selection_box_3").visible = false
	get_node("selection_boxes/selection_box_4").visible = false

	match(options.size()):
		2:
			get_node("selection_boxes/selection_box_2").visible = true
			option_nodes[0] = get_node("selection_boxes/selection_box_2/option_1")
			option_nodes[1] = get_node("selection_boxes/selection_box_2/option_2")
		3:
			get_node("selection_boxes/selection_box_3").visible = true
			option_nodes[0] = get_node("selection_boxes/selection_box_3/option_1")
			option_nodes[1] = get_node("selection_boxes/selection_box_3/option_2")
			option_nodes[2] = get_node("selection_boxes/selection_box_3/option_3")
		4:
			get_node("selection_boxes/selection_box_4").visible = true
			option_nodes[0] = get_node("selection_boxes/selection_box_4/option_1")
			option_nodes[1] = get_node("selection_boxes/selection_box_4/option_2")
			option_nodes[2] = get_node("selection_boxes/selection_box_4/option_3")
			option_nodes[3] = get_node("selection_boxes/selection_box_4/option_4")
	
	for i in range(0, options.size()):
		option_nodes[i].set_option(options[i])
		option_nodes[i].deselect()
	
	option_nodes[0].select()

func _on_scroll_timer_timeout():
	get_node("box/text_box").visible_characters += 1
	
	if(get_node("box/text_box").percent_visible >= 1):
		finished = true
	
		get_node("scroll_timer").stop()
		
		emit_signal("text_finished_scrolling")

		if(is_using_options()):
			set_options_active(true)
			