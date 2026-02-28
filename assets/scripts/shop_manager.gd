extends Control

func _process(delta: float) -> void:
	$coins_label.text = "Coins: {coins}".format({"coins": Globals.coins})	
	$toucan_label.text = "Toucan\nOwned: {owned}\nCost: {cost}$".format({"owned": Globals.toucan_upgrades, "cost": Globals.TOUCAN_PRICE * (Globals.toucan_upgrades + 1)})
	$blahaj_label.text = "Blahaj\nOwned: {owned}\nCost: {cost}$".format({"owned": Globals.blahaj_upgrades, "cost": Globals.BLAHAJ_PRICE * (Globals.blahaj_upgrades + 1)})
	$sell_cost_upgrade.text = "Sell cost upgrade\n(+1$)\nOwned: {owned}\nCost: {cost}$".format({"owned": Globals.sell_cost_upgrades, "cost": Globals.SELL_COST_PRICE * (Globals.sell_cost_upgrades + 1)})
	$fish_spawn_upgrade.text = "Fish Spawn Speed upgrade\n(+ 1 fish/s)\nOwned: {owned}\nCost: {cost}$".format({"owned": Globals.spawn_speed_upgrades, "cost": Globals.SPAWN_SPEED_PRICE * (Globals.spawn_speed_upgrades + 1)})
