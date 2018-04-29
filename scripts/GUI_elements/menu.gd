extends PopupPanel

var popped_up = false

func _process(delta):
	if(Input.is_action_just_pressed("ui_escape")):
		print("LISTENING")
		if(not popped_up):
			#get_tree().set_pause(true)
			popped_up = true
			popup()
			get_tree().set_pause(true)
			$ItemList/exit_button.grab_focus()
		else:
			popped_up = false
			hide()
			
			get_tree().set_pause(false)

func _on_menu_about_to_show():
	pass

func _on_exit_button_pressed():
	popped_up = false
	hide()
	get_tree().set_pause(false)
