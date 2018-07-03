tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("LayerChanger", "Node", preload("layer_changer.gd"), preload("node.svg"))

func _exit_tree():
	remove_custom_type("LayerChanger")