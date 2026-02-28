extends Button

func _pressed() -> void:
	if Globals.coins >= Globals.SPAWN_SPEED_PRICE * (Globals.spawn_speed_upgrades + 1):
		Globals.coins -= Globals.SPAWN_SPEED_PRICE * (Globals.spawn_speed_upgrades + 1)
		Globals.spawn_speed_upgrades += 1
