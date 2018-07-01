tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("CameraLimitArea", "Area2D", preload("camera_limit_area.gd"), null)
	add_custom_type("ExtendedCamera2D", "Camera2D", preload("extended_camera_2D.gd"), null)

func _exit_tree():
	remove_custom_type("CameraLimitArea")
	remove_custom_type("ExtendedCamera2D")