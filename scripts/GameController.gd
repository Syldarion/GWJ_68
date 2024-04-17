extends Node2D

var the_smith
var ui_exp_bar : TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	the_smith = find_child("TheSmith")
	the_smith.exp_gained.connect(_on_player_gained_exp)
	ui_exp_bar = find_child("EXPBar")
	
	the_smith.active_upgrades.append("Hammer_Damage1")
	print(choose_from_available_upgrades(3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_gained_exp(current, max, level):
	ui_exp_bar.max_value = max
	ui_exp_bar.value = current


func choose_from_available_upgrades(count):
	var available_upgrades = get_available_upgrades(the_smith.active_upgrades)
	available_upgrades.shuffle()
	return available_upgrades.slice(0, count)


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
