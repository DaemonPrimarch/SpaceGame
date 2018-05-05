extends Sprite

export var enabled = true
export var flickering = false
onready var light = get_node("Light2D")

var time_list = []
var time = 0
var current_list

func _ready():
	randomize()
	if(flickering):
		var length = floor(rand_range(15,40))
		var i = 0
		while (i < length):
			time_list.append(rand_range(1.0, 8.0))
			i+=1
		time_list.sort()
		current_list = time_list.duplicate()
	if(not enabled):
		light.enabled = false

func _process(delta):
	if(flickering and enabled):
		time += delta
		for flick in current_list:
			if(abs(time - flick) < 0.1):
				light.enabled = not light.enabled
				print("flick " , flick)
				current_list.erase(flick)
				
		if(time > time_list[time_list.size() - 1]):
			time = 0
			current_list = time_list.duplicate()
			print("restart")

func enable():
	enabled = true

