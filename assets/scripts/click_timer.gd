extends Timer

func _on_timeout() -> void:
	Globals.last_fish_per_second = Globals.fish_per_second
	Globals.fish_per_second = 0
	if Globals.all_hit > 0:
		Globals.last_hit_percent = min((float(Globals.successful_hit) / float(Globals.all_hit)) * 100, 100.0)
	else:
		Globals.last_hit_percent = 0
	Globals.successful_hit = 0
	Globals.all_hit = 0
