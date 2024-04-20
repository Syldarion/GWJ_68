extends Node2D

@export var upgrade_screen_scene : PackedScene
@export var hammer_minigame_scene : PackedScene

@export var spawn_data : Array[SpawnWaveData] = []

var the_smith
var game_ui_controller
var entity_spawner
var upgrade_screen
var game_camera
var spawned_upgrade_anvil

var available_upgrades = 0
var game_time_seconds = 0

var current_wave = 0
var time_between_waves = 10
var time_since_wave = 0

var kills = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	the_smith = find_child("TheSmith")
	the_smith.exp_gained.connect(_on_player_gained_exp)
	the_smith.leveled_up.connect(_on_player_leveled_up)
	the_smith.anvil_picked_up.connect(_on_player_picked_up_anvil)
	game_ui_controller = $GameUI
	game_ui_controller.set_timer_text("00:00")
	game_ui_controller.set_kill_count_text("0")
	entity_spawner = find_child("EntitySpawner")
	game_camera = find_child("FocusCamera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	game_time_seconds += delta
	game_ui_controller.set_timer_text(format_time(game_time_seconds))
	
	time_since_wave += delta
	if time_since_wave >= time_between_waves:
		spawn_new_wave()


func format_time(seconds):
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds) % 60
	return "%02d:%02d" % [minutes, remaining_seconds]


func _on_player_gained_exp(current, max, level):
	game_ui_controller.set_exp_bar_values(0, max, current)


func _on_player_leveled_up(level):
	print("player is at level " + str(level))
	available_upgrades += 1


func _on_player_picked_up_anvil():
	if available_upgrades > 0:
		spawned_upgrade_anvil = entity_spawner.spawn_entity("anvil", the_smith.global_position + Vector2.RIGHT * 16)
		game_camera.enter_focus_zoom()
		show_new_upgrade()
		get_tree().paused = true


func show_new_upgrade():
	var new_upgrade_screen = upgrade_screen_scene.instantiate()
	add_child(new_upgrade_screen)
	var upgrade_choices = choose_from_available_upgrades(3)
	for choice in upgrade_choices:
		new_upgrade_screen.add_option_to_list(choice, UpgradeLibrary.UPGRADES[choice])
	new_upgrade_screen.upgrade_selected.connect(_on_upgrade_screen_selected.bind(new_upgrade_screen))


func choose_from_available_upgrades(count):
	var available_upgrades = get_available_upgrades(the_smith.active_upgrades)
	available_upgrades.shuffle()
	return available_upgrades.slice(0, count)


func _on_upgrade_screen_selected(upgrade_name, upgrade_screen):
	available_upgrades -= 1
	print_debug(available_upgrades)
	# the_smith.add_upgrade(upgrade_name, UpgradeLibrary.UPGRADES[upgrade_name])
	upgrade_screen.queue_free()
	run_minigame(upgrade_name)
	get_tree().paused = false


func run_minigame(upgrade_name):
	var new_hammer_minigame = hammer_minigame_scene.instantiate()
	add_child(new_hammer_minigame)
	new_hammer_minigame.global_position = the_smith.global_position
	new_hammer_minigame.hammer_struck.connect(_on_minigame_hammer_strike)
	new_hammer_minigame.minigame_done.connect(finish_minigame.bind(new_hammer_minigame, upgrade_name))


func _on_minigame_hammer_strike(effect_added):
	print_debug(effect_added)
	var shockwave = entity_spawner.spawn_entity("shockwave", spawned_upgrade_anvil.global_position)
	shockwave.z_index = -1
	shockwave.shockwave(64.0, 256.0, 10, 200)
	game_camera.add_trauma(0.2)


func deep_copy_dictionary(original):
	var copy = {}
	for key in original.keys():
		var value = original[key]
		if typeof(value) == TYPE_DICTIONARY:
			copy[key] = deep_copy_dictionary(value)
		else:
			copy[key] = value
	return copy


func finish_minigame(minigame_value, minigame_screen, upgrade_name):
	print_debug(minigame_value)
	
	var upgrade_data = deep_copy_dictionary(UpgradeLibrary.UPGRADES[upgrade_name])
	if upgrade_data.has("effect") and typeof(upgrade_data["effect"]) == TYPE_DICTIONARY:
		for key in upgrade_data["effect"].keys():
			if typeof(upgrade_data["effect"][key]) in [TYPE_FLOAT, TYPE_INT]:
				upgrade_data["effect"][key] *= (1.0 + minigame_value)
			else:
				print_debug("Non numerical value encountered...")
	
	the_smith.add_upgrade(upgrade_name, upgrade_data)
	
	spawned_upgrade_anvil.queue_free()
	game_camera.leave_focus_zoom()
	minigame_screen.queue_free()


func is_upgrade_available(upgrade_name, current_upgrades):
	if upgrade_name in current_upgrades:
		return false
	var upgrade = UpgradeLibrary.UPGRADES[upgrade_name]
	for prerequisite in upgrade.prerequisites:
		if prerequisite not in current_upgrades:
			return false
	return true


func get_available_upgrades(current_upgrades):
	var available = []
	for upgrade_name in UpgradeLibrary.UPGRADES:
		if is_upgrade_available(upgrade_name, current_upgrades):
			available.append(upgrade_name)
	return available


func spawn_new_wave():
	var enemy_data = spawn_data[current_wave % spawn_data.size()]
	var spawned_enemies = entity_spawner.spawn_wave_offscreen(enemy_data)
	
	for enemy in spawned_enemies:
		enemy.enemy_died.connect(_on_enemy_died)
	
	current_wave += 1
	time_since_wave = 0


func _on_enemy_died(death_loc):
	kills += 1
	game_ui_controller.set_kill_count_text(str(kills))
