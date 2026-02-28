extends Node2D
@onready var fish_parent: Node2D = $fish_parent
@onready var coinText: RichTextLabel = $Control/coins_label
@onready var audio_player = $"ClickSoundManager"
var last_bubble = Time.get_ticks_msec()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		Globals.all_hit += 1

func play_sound(path: String):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(path)
	player.play()
	player.finished.connect(player.queue_free)

func spawn_blahaj() -> void:
	var new_blahaj: Area2D = $blahaj_area2d.duplicate(15)
	new_blahaj.set_meta("is_original", false)
	var new_blahaj_size = new_blahaj.get_child(0).texture.get_size() * new_blahaj.get_child(0).scale
	new_blahaj.position = Vector2(
			randf_range(DisplayServer.window_get_size().x * 0.1, Globals.spawn_area.x - new_blahaj_size.x),
			randf_range(DisplayServer.window_get_size().y * 0.1, Globals.spawn_area.y - new_blahaj_size.y)
	)
	
	add_child(new_blahaj)
	
func spawn_toucan() -> void:
	var new_toucan: Area2D = $toucan_area2d.duplicate(15)
	new_toucan.set_meta("is_original", false)
	var new_toucan_size = new_toucan.get_child(0).texture.get_size()
	new_toucan.position = Vector2(
			randf_range(DisplayServer.window_get_size().x * 0.1, Globals.spawn_area.x - new_toucan_size.x),
			-new_toucan_size.y * 2
	)
	
	add_child(new_toucan)
	
func spawn_bubble() -> void:
	var new_bubble: Sprite2D = $bubble_to_clone.duplicate(15)
	new_bubble.set_meta("is_original", false)
	var new_bubble_size = new_bubble.texture.get_size()
	new_bubble.position = Vector2(
			randf_range(0, DisplayServer.window_get_size().x - new_bubble_size.x),
			DisplayServer.window_get_size().y
	)
	add_child(new_bubble)

func _ready() -> void:
	audio_player.play()
	Globals.init_button($fish_parent/fish_area2d)
	get_viewport().size_changed.connect(_on_window_resized)
	
	var spawn_time: float = (1.0 / (4.0 + Globals.spawn_speed_upgrades))	
	$spawn_timer.wait_time = spawn_time
	
	for i in Globals.blahaj_upgrades:
		spawn_blahaj()

	for i in Globals.toucan_upgrades:
		spawn_toucan()

func _on_window_resized() -> void:
	Globals.spawn_area = DisplayServer.window_get_size()

func _process(_delta: float) -> void:
	coinText.text = "Coins: {coins}\nFish per second: {fish_per_second}\nHit rate: {hit_rate}%".format({"coins": Globals.coins, "fish_per_second": round(Globals.last_fish_per_second / 3.0), "hit_rate": round(Globals.last_hit_percent)})
	
	if Time.get_ticks_msec() - last_bubble >= 100:
		last_bubble = Time.get_ticks_msec()
		spawn_bubble()
