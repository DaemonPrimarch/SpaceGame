extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	visible = ProjectSettings.get_setting("debug/settings/debug_labels_enabled")