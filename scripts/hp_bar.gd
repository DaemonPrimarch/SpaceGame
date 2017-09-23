extends ProgressBar

var player

func _ready():
	set_min(0);

func set_player(p):
	if(player != null):
		unset_player()
	player = p
	p.connect("hp_changed", self, "hp_changed")
	set_max(p.max_HP)
	set_value(p.hp)
	set_step(1)

func unset_player():
	player.disconnect("hp_changed", self, "hp_changed")
	player = null

func hp_changed():
	set_value(player.hp)
	update()

func destroy():
	unset_player()
	queue_free()