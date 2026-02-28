# In Globals
extends Node

var coins: int = 0
var fish_per_second: int = 0
var last_fish_per_second: int = 0
var spawn_area: Vector2
var fish_button_to_clone: Area2D
var successful_hit = 0
var all_hit = 0
var last_hit_percent = 0
var sell_cost_upgrades = 0
var spawn_speed_upgrades = 0
var blahaj_upgrades = 0
var toucan_upgrades = 1

const COD_TYPES := ["blue", "green", "orange", "pink", "purple", "yellow"]

const FISH_SPEED = 100
const BLAHAJ_SPEED = 150
const TOUCAN_SPEED = 250
const BUBBLE_SPEED = 100

const SELL_COST_PRICE = 225
const SPAWN_SPEED_PRICE = 300
const BLAHAJ_PRICE = 400
const TOUCAN_PRICE = 75

func init_button(button: Area2D):
	fish_button_to_clone = button
	spawn_area = Vector2(DisplayServer.window_get_size())
