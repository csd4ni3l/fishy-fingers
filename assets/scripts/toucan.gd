extends Sprite2D

var nearest_fish: Area2D
var last_eat = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if get_parent().get_meta("is_original", false):
		return
		
	if not Time.get_ticks_msec() - last_eat >= 700:
		return
	
	var min_dist: float = INF
	nearest_fish = null

	for fish in get_node("/root/Main/fish_parent").get_children():
		if not is_instance_of(fish, Area2D):
			continue
		var dist = global_position.distance_to(fish.global_position)
						
		if fish.global_position.y < (DisplayServer.window_get_size().y * 0.35) and dist < min_dist:
			min_dist = dist
			nearest_fish = fish

	if not is_instance_valid(nearest_fish) or nearest_fish.position.y > (DisplayServer.window_get_size().y * 0.35):
		respawn()
		return

	var direction = ((nearest_fish.global_position - global_position) * randf_range(0.9, 1.1)).normalized()
	get_parent().position += direction * Globals.TOUCAN_SPEED * delta
	get_parent().rotation = lerp_angle(get_parent().rotation, direction.angle(), 0.025)
		
	for area: Area2D in get_parent().get_overlapping_areas():
		if area.is_in_group("fish"):
			Globals.coins += (1 + Globals.sell_cost_upgrades)
			Globals.fish_per_second += 1
			area.queue_free()
			respawn()
			play_sound("res://assets/sfx/splash.mp3")
			last_eat = Time.get_ticks_msec()
			
func play_sound(path: String):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(path)
	player.play()
	player.finished.connect(player.queue_free)
					
func respawn() -> void:
	var new_toucan_size = self.texture.get_size()
	
	get_parent().position = Vector2(
		randf_range(DisplayServer.window_get_size().x * 0.1, Globals.spawn_area.x - new_toucan_size.x),
		-new_toucan_size.y * 2
	)
