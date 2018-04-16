tool
extends EditorPlugin

var dock # A class member to hold the dock during the plugin lifecycle

func _enter_tree():
    # Initialization of the plugin goes here
    # First load the dock scene and instance it:
	dock = preload("res://addons/dialog_editor/button.tscn").instance()

    # Add the loaded scene to the docks:
	 #add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	add_control_to_container(CONTAINER_TOOLBAR, dock)
	
	dock.connect("pressed", self, "open")

    # Note that LEFT_UL means the left of the editor, upper-left dock

func _exit_tree():
    # Clean-up of the plugin goes here
    # Remove the scene from the docks:
    remove_control_from_docks(dock) # Remove the dock
	
func open():
	var window = preload("res://addons/dialog_editor/window.tscn").instance()
	
	add_child(window)
	
	window.popup()