tool

extends Node2D

signal player_entered(player)

func _ready():
	print("TEST 1")
	connect("player_entered", self, "_on_player_enter")

func _on_player_enter(player):
	print("player_enter")