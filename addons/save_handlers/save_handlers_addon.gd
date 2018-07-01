tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BooleanSaveReader", "Node", preload("save_boolean_reader.gd"), null)
	add_custom_type("FromSaveValueSetter", "Node", preload("from_save_value_setter.gd"), null)

func _exit_tree():
	remove_custom_type("BooleanSaveReader")
	remove_custom_type("FromSaveValueSetter")