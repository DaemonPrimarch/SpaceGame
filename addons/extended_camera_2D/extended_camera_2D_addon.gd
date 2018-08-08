tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("CameraLimitArea", "Area2D", preload("camera_limit_area.gd"), preload("area.svg"))
	add_custom_type("CameraOffsetChanger", "Area2D", preload("camera_offset_changer.gd"), preload("area.svg"))
	add_custom_type("CameraLimitCustomRect", "Polygon2D", preload("camera_limit_custom_rect.gd"), null)
	add_custom_type("ExtendedCamera2D", "Camera2D", preload("extended_camera_2D.gd"), preload("camera.svg"))
	add_custom_type("CameraLimitRect", "Polygon2D", preload("camera_limit_rect.gd"), null)
	add_custom_type("LimitRectSetter", "Area2D", preload("limit_rect_setter.gd"), null)

func _exit_tree():
	remove_custom_type("CameraLimitArea")
	remove_custom_type("ExtendedCamera2D")
	remove_custom_type("CameraLimitCustomRect")
	remove_custom_type("CameraOffsetChanger")
	remove_custom_type("CameraLimitRect")
	remove_custom_type("LimitRectSetter")