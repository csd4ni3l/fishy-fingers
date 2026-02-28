extends Node2D

var changing_scene := false
var anim_start = Time.get_ticks_msec()

func spawn_bubble() -> void:
	var new_bubble: Sprite2D = $bubble_to_clone.duplicate(15)
	new_bubble.set_meta("is_original", false)
	var new_bubble_size = new_bubble.texture.get_size()
	new_bubble.position = Vector2(
		randf_range(0, DisplayServer.window_get_size().x - new_bubble_size.x),
		randf_range(0, DisplayServer.window_get_size().y - new_bubble_size.y)
	)
	add_child(new_bubble)

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - anim_start >= 5000:
		get_tree().change_scene_to_file("res://assets/scenes/game.tscn")

func _ready() -> void:
	var screen = DisplayServer.window_get_size()
	var bubble_size = $bubble_to_clone.texture.get_size()
	var cols = ceil(screen.x / bubble_size.x) + 1
	var rows = ceil(screen.y / bubble_size.y) + 1
	for i in range(cols * rows):
		spawn_bubble()
