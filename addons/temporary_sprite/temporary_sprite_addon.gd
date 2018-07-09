tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("TemporarySprite", "Panel", preload("temporary_sprite.gd"), preload("panel.svg"))

func _exit_tree():
	remove_custom_type("TemporarySprite")