extends Timer

@onready var fish_button_to_clone = get_node("../fish_parent/fish_area2d")
@onready var fish_parent = get_node("../fish_parent")

func get_sprite_size(sprite: Sprite2D) -> Vector2:
	if sprite.texture:
		if sprite.region_enabled:
			return sprite.region_rect.size * sprite.scale
		return sprite.texture.get_size() * sprite.scale
	return Vector2.ZERO

func spawn() -> void:
	var fish_area: Area2D = fish_button_to_clone.duplicate(15)
	fish_area.get_child(0).texture = load("res://assets/graphics/{type}_cod.png".format({"type": Globals.COD_TYPES[randi() % Globals.COD_TYPES.size()]}))
	fish_area.set_meta("is_original", false)
	fish_area.visible = true
	fish_area.get_child(0).visible = true
	
	fish_parent.add_child(fish_area)

	var fish_size = get_sprite_size(fish_button_to_clone.get_child(0))
	fish_area.position = Vector2(
		randf_range(0, Globals.spawn_area.x - fish_size.x),
		randf_range(0, Globals.spawn_area.y - fish_size.y)
	)
						
func _on_timeout() -> void:
	spawn()
