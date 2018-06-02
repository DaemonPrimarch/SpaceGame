extends AnimationPlayer

func play_or_continue(animation):
	if(not current_animation == animation):
		play(animation)