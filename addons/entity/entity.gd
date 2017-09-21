tool
extends EditorPlugin

func _enter_tree():
     add_custom_type("Entity", "KinematicBody2D", preload("entity_behaviour.gd"), preload("icon.png"))


func _exit_tree():
    remove_custom_type("Entity")