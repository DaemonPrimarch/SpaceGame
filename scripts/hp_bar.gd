extends ProgressBar

var player

func _ready():
	set_min(0);
	set_process(true)

func _process(delta):
	player.hp -= 0.1
	print(player.hp)

func set_player(p):
	if(p != null):
		unset_player()
	player = p
	# connect listeners on player
	set_max(p.max_HP)
	set_value(p.get_HP())

func unset_player():
	# disconnect listeners on player
	player = null

func destroy():
	unset_player()
	queue_free()