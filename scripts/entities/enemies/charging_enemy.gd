tool
extends "res://scripts/entities/enemies/enemy.gd"

var charging_distance

func _on_bullet_hit(bullet):
	if(get_direction().x > 0):
		if(get_position().x - bullet.get_position().x > 0):
			#hit
			damage(bullet.get_damage())
		else:
			#miss
			pass
	else:
		if(get_position().x - bullet.get_position().x < 0):
			#hit
			damage(bullet.get_damage())
		else:
			#miss
			pass

func _init():
	add_state("IDLE")
	add_state("CHARGING")
	add_state("STUNNED_BY_CRASH")
	add_state("STUNNED_BY_EXHAUSTION")
	
	set_state("IDLE")

