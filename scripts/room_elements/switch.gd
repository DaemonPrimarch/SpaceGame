tool

extends Node

signal switched_on
signal switched_off

export var state = false setget set_state

func set_state(new_state):
	if(new_state):
		switch_on()
	else:
		switch_off()

func switch_on():
	if(not is_on()):
		state = true
		
		emit_signal("switched_on")

func switch_off():
	if(is_on()):
		state = false
		
		emit_signal("switched_off")

func is_on():
	return state

func toggle():
	if(is_on()):
		switch_off()
	else:
		switch_on()