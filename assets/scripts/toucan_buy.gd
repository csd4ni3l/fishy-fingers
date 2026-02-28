extends TextureButton

func _pressed() -> void:
	if Globals.coins >= Globals.TOUCAN_PRICE * (Globals.toucan_upgrades + 1):
		Globals.coins -= Globals.TOUCAN_PRICE * (Globals.toucan_upgrades + 1)
		Globals.toucan_upgrades += 1
