extends Sprite2D

func scale_to_window():
	var window_size = get_viewport_rect().size
	var texture_size = texture.get_size()
	scale = window_size / texture_size
	position = window_size / 2  # Center it (origin is top-left by default)

func _process(delta: float) -> void:
	scale_to_window()
