extends Label

func _ready():
	visible = ProjectSettings.get_setting("debug/settings/debug_labels_enabled")