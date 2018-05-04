tool
extends WindowDialog

var current_tree
var current_index
var previouses = {}
var playing_full = false

func _ready():
	_on_new_file_button_pressed()
	
func set_current_tree(tree):
	previouses = {}
	set_current_element(tree.start)
	current_tree = tree

func set_current_element(ind):
	current_index = ind
	
	var elem = current_tree[current_index]
	
	$inputs/next_prev/next/next_button.visible = elem.has("next")
	
	$inputs/current_id/identifier.text = ind
	
	if(elem.has("next")):
		$inputs/next_prev/next/edit/next_name_edit.text = elem.next
		$inputs/next_prev/create/insert_next.visible = true
		$inputs/next_prev/create/create_next.visible = false
	else:
		$inputs/next_prev/create/insert_next.visible = false
		$inputs/next_prev/create/create_next.visible = true
		$inputs/next_prev/next/edit/next_name_edit.text = ""
		
	$inputs/next_prev/prev/previous_button.visible = previouses.has(ind)

	if(previouses.has(ind)):
		$inputs/next_prev/prev/edit/previous_name_edit.text = previouses[ind]
	else:
		$inputs/next_prev/prev/edit/previous_name_edit.text = ""
	
	if(elem.has("name")):
		$inputs/name/name_edit.text = elem.name
	else:
		$inputs/name/name_edit.text = ""
	
	if(elem.has("scroll_speed")):
		$inputs/scroll_speed/scroll_speed_edit.text = str(elem.scroll_speed)
	else:
		$inputs/scroll_speed/scroll_speed_edit.text = str($preview/dialog_box.default_scroll_speed)
	
	if(elem.has("next_indicator")):
		$inputs/advance/next_indicator/next_indicator.pressed = elem.next_indicator
	else:
		$inputs/advance/next_indicator/next_indicator.pressed = false
	
	if(elem.has("auto_advance")):
		$inputs/advance/auto_advance/auto_advance.pressed = elem.auto_advance
	else:
		$inputs/advance/auto_advance/auto_advance.pressed = false
	
	$inputs/message/message_edit.text = elem.text
	
	print(elem.text)
	
func get_current_element():
	return current_tree[current_index]

func _on_previous_button_pressed():
	set_current_element(previouses[current_index])

func _on_next_button_pressed():
	previouses[get_current_element().next] = current_index
	set_current_element(get_current_element().next)

func _on_play_button_pressed():
	print(get_current_element())
	
	if(get_current_element().has("name")):
		$preview/dialog_box.set_using_name(true)
		$preview/dialog_box.set_speaker_name(get_current_element().name)
	else:
		$preview/dialog_box.set_using_name(false)
		
	$preview/dialog_box.set_text(get_current_element().text)
	
	if(get_current_element().has("options")):
		$preview/dialog_box.set_using_options(true)
		$preview/dialog_box.set_options(get_current_element().options)
	else:
		$preview/dialog_box.set_using_options(false)
		
	if(get_current_element().has("scroll_speed")):
		$preview/dialog_box.set_text_scroll_speed(get_current_element().scroll_speed)
	else:
		$preview/dialog_box.set_text_scroll_speed($preview/dialog_box.default_scroll_speed)
	
	$preview/dialog_box.start_dialog()

func _on_name_edit_text_changed(new_text):
	get_current_element().name = new_text

func _on_message_edit_text_changed():
	get_current_element().text = $inputs/message/message_edit.text

func _on_scroll_speed_edit_text_changed(new_text):
	get_current_element().scroll_speed = int(new_text)

func _on_next_name_edit_text_changed(new_text):
	if(new_text == ""):
		get_current_element().erase("next")
	else:
		get_current_element().next = new_text
	
	$inputs/next_prev/next/next_button.visible = get_current_element().has("next")

func _on_open_file_button_pressed():
	$open_dialog.popup()

func _on_dialog_box_text_finished_scrolling():
	if(get_current_element().has("next") and playing_full):
		if(get_current_element().has("next_indicator")):
			if(get_current_element().next_indicator):
#				$inputs/message/message_edit.grab_focus()
#				$inputs/message/message_edit.grab_click_focus()
				$preview/dialog_box.set_next_indicator_enabled(true)
		if((get_current_element().has("next_indicator") and not get_current_element().next_indicator) or not get_current_element().has("next_indicator")):
			_on_next_button_pressed()
			_on_play_button_pressed()
	else:
		playing_full = false

func _on_play_full_button_pressed():
	playing_full = true
	set_current_element("start")
	_on_play_button_pressed()

func _on_auto_advance_toggled(button_pressed):
	get_current_element().auto_advance = button_pressed

func _on_next_indicator_toggled(button_pressed):
	get_current_element().next_indicator = button_pressed

func _on_dialog_box_pressed_continue():
	if(playing_full):
		_on_next_button_pressed()
		_on_play_button_pressed()

func _on_save_file_button_pressed():
	$save_dialog.current_path = $create_buttons/current_path.text
	$save_dialog.popup()

func _on_create_next_pressed():

	var name = $inputs/next_prev/create/next_create_name_edit.text
	if(name == "" or current_tree.has(name)):
		$inputs/next_prev/create/AcceptDialog.popup()
	else:
		get_current_element().next = name
	
		current_tree[name] = {"text":""}
		_on_next_button_pressed()

func _on_insert_next_pressed():
	pass # replace with function body

func _on_next_create_name_edit_text_changed(new_text):
	pass # replace with function body

func _on_save_dialog_file_selected(path):
	var file = File.new()
	file.open(path, file.WRITE)
	var json = to_json(current_tree)
	var text = file.store_string(json)
	file.close()

func _on_open_dialog_file_selected(path):
	path = path
	
	$create_buttons/current_path.text = path
	
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	current_tree = parse_json(text)
	
	set_current_element("start")

func _on_identifier_text_changed(new_text):
	pass # replace with function body

func _on_new_file_button_pressed():
	previouses = {}
	current_tree = {"start":{"text":""}}
	
	set_current_element("start")

func delete_element(ind):
	#previouses[ind]
	pass
	
func _on_remove_pressed():
	delete_element(current_index)
