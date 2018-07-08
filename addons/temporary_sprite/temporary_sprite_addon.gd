tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("TemporarySprite", "Panel", preload("temporary_sprite.gd"), preload("extended_animation_player.svg"))

func _exit_tree():
	remove_custom_type("TemporarySprite")