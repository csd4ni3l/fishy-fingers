extends Button

func _pressed() -> void:
	if Globals.coins >= Globals.SELL_COST_PRICE * (Globals.sell_cost_upgrades + 1):
		Globals.coins -= Globals.SELL_COST_PRICE * (Globals.sell_cost_upgrades + 1)
		Globals.sell_cost_upgrades += 1
