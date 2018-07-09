tool
extends "res://scripts/entities/enemies/enemy.gd"

var charging_distance

func _on_bullet_hit(bullet):
	if(not $bullet_protection_area.overlaps_area(bullet)):
		damage(bullet.get_damage())
	else:
		print("PROTEC")

func _init():
	add_state("IDLE")
	add_state("CHARGING")
	add_state("STUNNED_BY_CRASH")
	add_state("STUNNED_BY_EXHAUSTION")
	
	set_state("IDLE")