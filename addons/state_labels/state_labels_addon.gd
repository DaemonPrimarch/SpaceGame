tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("StringStateLabel", "Label", preload("state_label.gd"), preload("label.svg"))
	add_custom_type("BooleanStateLabel", "Label", preload("boolean_state_label.gd"), preload("label.svg"))

func _exit_tree():
	remove_custom_type("StringStateLabel")
	remove_custom_type("BooleanStateLabel")