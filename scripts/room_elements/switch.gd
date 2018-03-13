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
	state = true
		
	call_deferred("emit_signal", "switched_on")
	
	#print("SWITCHED ON!")

func switch_off():
	state = false
		
	call_deferred("emit_signal", "switched_off")
	
	#print("SWITCHED OFF!")

func is_on():
	return state

func toggle():
	if(is_on()):
		switch_off()
	else:
		switch_on()