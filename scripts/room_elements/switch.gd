tool

extends Node

signal switched_on
signal switched_off

export var state = false setget set_state

func _enter_tree():	
	add_to_group("switch")

func set_state(new_state):
	if(new_state):
		switch_on()
	else:
		switch_off()

func switch_on():
	state = true
	
	call_deferred("emit_signal", "switched_on")

func switch_off():
	state = false
	
	call_deferred("emit_signal", "switched_off")

func is_on():
	return state

func toggle():
	if(is_on()):
		switch_off()
	else:
		switch_on()
		
export var toggleable = false
var toggled = false

func is_toggleable():
	return toggleable

func _on_bullet_hit(bullet):
	if(is_toggleable()):
		toggle()
	else:
		if(not toggled):
			switch_on()
			toggled = true