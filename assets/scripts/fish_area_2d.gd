extends Area2D

@onready var sprite = $fish_button_to_clone  # or whatever the sprite node is named
@onready var audio_player = get_node("/root/Main/ClickSoundManager")
var does_move = 1
var speed_scale = 1.0
var new_rotation: float
var is_reeling = false
var reel_speed = 800.0
var line_origin: Vector2
var line: Line2D
var hook_sprite: Sprite2D
var wobble = 0.0
var angle = randi() % 360
var last_bubble_spawn = Time.get_ticks_msec()

func get_size() -> Vector2:
	if sprite.texture:
		return sprite.texture.get_size() * sprite.scale
	return Vector2.ZERO

func play_sound(path: String):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(path)
	player.play()
	player.finished.connect(player.queue_free)

func spawn_bubble() -> void:
	var new_bubble: Sprite2D = $"/root/Main/bubble_to_clone".duplicate(15)
	new_bubble.set_meta("is_original", false)
	new_bubble.position = Vector2(
			global_position.x * randf_range(0.95, 1.05),
			global_position.y
	)
	get_parent().get_parent().get_parent().add_child(new_bubble)

func _physics_process(delta: float) -> void:
	if get_meta("is_original", false):
		return
		
	var sz = get_size()
	if is_reeling:
		if Time.get_ticks_msec() - last_bubble_spawn >= 20:
			last_bubble_spawn = Time.get_ticks_msec()
			spawn_bubble()
		
		global_position.y -= reel_speed * delta
		global_position.x = line_origin.x  # no offset
		if line and is_instance_valid(line):
			line.set_point_position(0, line_origin)
			line.set_point_position(1, global_position)
		if hook_sprite and is_instance_valid(hook_sprite):
			hook_sprite.global_position = global_position - Vector2(0, get_size().y / 5)
		if global_position.y + get_size().y <= 0:
			_on_caught()
		return

	if does_move == 1:
		var mouse = get_global_mouse_position()
		var top_left = global_position - sz / 2
		var rect = Rect2(top_left, sz)
		if rect.has_point(mouse):
			speed_scale = 0.6
		else:
			speed_scale = 1.0
		new_rotation = angle - deg_to_rad(135)
		if abs(new_rotation - rotation) > 0.01:
			rotation = lerp_angle(rotation, new_rotation, 0.2)
		else:
			rotation = new_rotation

		wobble += delta * 15.0
		var wobble_angle = angle + sin(wobble) * 0.3
		var wobble_dir = Vector2(cos(wobble_angle), sin(wobble_angle))

		global_position += wobble_dir * Globals.FISH_SPEED * delta * speed_scale

		new_rotation = wobble_angle - deg_to_rad(135)
		if abs(new_rotation - rotation) > 0.01:
			rotation = lerp_angle(rotation, new_rotation, 0.2)
		else:
			rotation = new_rotation

		var screen_size = get_viewport_rect().size
		if global_position.x < 0:
			if is_instance_valid(line):
				line.queue_free()
			if is_instance_valid(hook_sprite):
				hook_sprite.queue_free()
			queue_free()
		elif global_position.x > screen_size.x:
			if is_instance_valid(line):
				line.queue_free()
			if is_instance_valid(hook_sprite):
				hook_sprite.queue_free()
			queue_free()
			
		if global_position.y < 0:
			global_position.y = -global_position.y
			self.angle = -self.angle
		elif global_position.y > screen_size.y:
			global_position.y = 2 * screen_size.y - global_position.y
			self.angle = -self.angle

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_on_clicked()

func _on_clicked() -> void:
	if is_reeling:
		return
	var fish_center = global_position
	line_origin = Vector2(fish_center.x, 0)

	line = Line2D.new()
	line.width = 2.0
	line.default_color = Color(0.6, 0.6, 0.6, 1.0)
	line.top_level = true
	line.points = PackedVector2Array([line_origin, fish_center])
	add_child(line)

	hook_sprite = Sprite2D.new()
	hook_sprite.texture = load("res://assets/graphics/hook.png")
	hook_sprite.top_level = true
	hook_sprite.global_position = fish_center - Vector2(0, get_size().y / 5)
	hook_sprite.scale = Vector2(1.5, 1.5)
	add_child(hook_sprite)

	is_reeling = true
	does_move = 0
	rotation = 0
	play_sound("res://assets/sfx/splash.mp3")

func _on_caught() -> void:
	Globals.coins += (1 + (Globals.sell_cost_upgrades * 0.5))
	Globals.fish_per_second += 1
	Globals.successful_hit += 1
	if line and is_instance_valid(line):
		line.queue_free()
	if hook_sprite and is_instance_valid(hook_sprite):
		hook_sprite.queue_free()
	queue_free()
