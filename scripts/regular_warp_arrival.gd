tool

extends Position2D

func change_name():
	if(Engine.is_editor_hint() and get_parent().get_destination_room() != null):
		set_name(get_parent().get_destination_room().get_state().get_node_name(0) +"_arrival")