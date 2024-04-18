extends Node2D

@export var upgrade_screen_scene : PackedScene

var the_smith
var ui_exp_bar : TextureProgressBar
var entity_spawner
var upgrade_screen
var game_camera

var available_upgrades = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	the_smith = find_child("TheSmith")
	the_smith.exp_gained.connect(_on_player_gained_exp)
	the_smith.leveled_up.connect(_on_player_leveled_up)
	the_smith.anvil_picked_up.connect(_on_player_picked_up_anvil)
	ui_exp_bar = find_child("EXPBar")
	entity_spawner = find_child("EntitySpawner")
	game_camera = find_child("FocusCamera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_gained_exp(current, max, level):
	ui_exp_bar.max_value = max
	ui_exp_bar.value = current


func _on_player_leveled_up(level):
	print("player is at level " + str(level))
	available_upgrades += 1


func _on_player_picked_up_anvil():
	if available_upgrades > 0:
		var upgrade_anvil = entity_spawner.spawn_entity("anvil", the_smith.global_position + Vector2.RIGHT * 16)
		game_camera.enter_focus_zoom()
		show_new_upgrade()
		get_tree().paused = true


func show_new_upgrade():
	var new_upgrade_screen = upgrade_screen_scene.instantiate()
	add_child(new_upgrade_screen)
	var upgrade_choices = choose_from_available_upgrades(3)
	for choice in upgrade_choices:
		new_upgrade_screen.add_option_to_list(choice, UpgradeLibary.UPGRADES[choice])
	new_upgrade_screen.upgrade_selected.connect(_on_upgrade_screen_selected.bind(new_upgrade_screen))


func choose_from_available_upgrades(count):
	var available_upgrades = get_available_upgrades(the_smith.active_upgrades)
	available_upgrades.shuffle()
	return available_upgrades.slice(0, count)


func _on_upgrade_screen_selected(upgrade_name, upgrade_screen):
	available_upgrades -= 1
	print_debug(available_upgrades)
	the_smith.add_upgrade(upgrade_name, UpgradeLibary.UPGRADES[upgrade_name])
	upgrade_screen.queue_free()
	if available_upgrades > 0:
		show_new_upgrade()
	else:
		get_tree().paused = false
		game_camera.leave_focus_zoom()

func is_upgrade_available(upgrade_name, current_upgrades):
	if upgrade_name in current_upgrades:
		return false
	var upgrade = UpgradeLibary.UPGRADES[upgrade_name]
	for prerequisite in upgrade.prerequisites:
		if prerequisite not in current_upgrades:
			return false
	return true


func get_available_upgrades(current_upgrades):
	var available = []
	for upgrade_name in UpgradeLibary.UPGRADES:
		if is_upgrade_available(upgrade_name, current_upgrades):
			available.append(upgrade_name)
	return available
