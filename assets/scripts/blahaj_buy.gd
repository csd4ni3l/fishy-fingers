extends TextureButton

func _pressed() -> void:
	if Globals.coins >= Globals.BLAHAJ_PRICE * (Globals.blahaj_upgrades + 1):
		Globals.coins -= Globals.BLAHAJ_PRICE * (Globals.blahaj_upgrades + 1)
		Globals.blahaj_upgrades += 1
