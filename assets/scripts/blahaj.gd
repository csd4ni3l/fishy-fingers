extends Sprite2D
var nearest_fish: Area2D
var last_eat = Time.get_ticks_msec()
var flip_timer: float = 0.0
var flip_delay: float = 0.15  
var current_direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if get_parent().get_meta("is_original", false):
		return
	
	var min_dist: float = INF
	nearest_fish = null
	for fish in get_node("/root/Main/fish_parent").get_children():
		if not is_instance_of(fish, Area2D):
			continue
		var dist = global_position.distance_to(fish.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest_fish = fish
	if not is_instance_valid(nearest_fish):
		return

	var chase = (nearest_fish.global_position - global_position).normalized()

	var separation = Vector2.ZERO
	for blahaj in get_node("/root/Main").get_children():
		if blahaj == get_parent():
			continue
		if not blahaj.is_in_group("blahaj"):
			continue
		var diff = get_parent().global_position - blahaj.global_position
		var dist = diff.length()
		if dist < 100.0 and dist > 0.0:
			separation += diff.normalized() * (100.0 - dist) / 100.0

	# Blend chase and separation, separation weighted more when close
	var desired = (chase + separation * 2.0).normalized()

	# Smoothly steer current_direction toward desired
	current_direction = current_direction.lerp(desired, 8.0 * delta).normalized()

	var speed = Globals.BLAHAJ_SPEED
	if separation.length() > 0.5:
		speed *= 2.5

	get_parent().position += current_direction * speed * delta
	get_parent().rotation = 0.0

	var target_scale_x = -1 if current_direction.x < 0 else 1
	if target_scale_x != get_parent().scale.x:
		flip_timer += delta
		if flip_timer >= flip_delay:
			get_parent().scale.x = target_scale_x
			flip_timer = 0.0
	else:
		flip_timer = 0.0

	if not Time.get_ticks_msec() - last_eat >= 500:
		return
	last_eat = Time.get_ticks_msec()
	for area: Area2D in get_parent().get_overlapping_areas():
		if area.is_in_group("fish"):
			Globals.coins += (1 + Globals.sell_cost_upgrades)
			Globals.fish_per_second += 1
			area.queue_free()
