extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_meta("is_original", false):
		return
	
	self.position.x += randf_range(-0.5, 0.5) * Globals.BUBBLE_SPEED * delta
	self.position.y -= Globals.BUBBLE_SPEED * delta

	if position.y < 0:
		queue_free()
