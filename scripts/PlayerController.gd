extends Node2D

@export var base_speed = 40
@export var throw_charge_buildup = 2
@export var max_throw_charge = 500
@export var interact_distance = 32
@export var swing_cooldown = 0.5
@export var mana_pull_range = 48.0
@export var mana_min_range = 4.0
@export var mana_pull_speed = 40.0
@export var attack_range = 32.0

@onready var charge_bar = $ChargeBar as TextureProgressBar

signal exp_gained(current, max, level)

var anvil_scene = preload("res://scenes/the_anvil.tscn")
var hammer_scene = preload("res://scenes/the_hammer.tscn")

var current_exp = 0
var exp_for_next_level = 100
var current_level = 0

var throw_charge = 0
var holding_anvil = true
var spawned_anvil = null

var time_since_last_swing = 0.0

var player_stats = {
	"speed_mult": 1.0,
	"hammer_damage": 60
}

var active_upgrades = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")
	
	charge_bar.min_value = 0
	charge_bar.max_value = max_throw_charge
	charge_bar.value = 0
	charge_bar.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = Vector2.ZERO
	if Input.is_action_pressed("MoveLeft"): movement.x -= 1.0
	if Input.is_action_pressed("MoveRight"): movement.x += 1.0
	if Input.is_action_pressed("MoveUp"): movement.y -= 1.0
	if Input.is_action_pressed("MoveDown"): movement.y += 1.0
	
	movement = movement.normalized()
	var speed = base_speed * player_stats.speed_mult
	
	translate(movement * speed * delta)
	
	if time_since_last_swing >= swing_cooldown:
		var closest_enemy = get_closest_enemy_in_range(attack_range)
		if closest_enemy:
			strike_enemy(closest_enemy)
		
	time_since_last_swing += delta
	
	if holding_anvil:
		if Input.is_action_pressed("Throw"):
			throw_charge = min(throw_charge + throw_charge_buildup * delta, max_throw_charge)
			charge_bar.visible = true
			charge_bar.value = throw_charge
		elif Input.is_action_just_released("Throw"):
			var mouse_pos = get_local_mouse_position()
			spawned_anvil = throw_anvil(throw_charge, mouse_pos)
			throw_charge = 0
			charge_bar.visible = false
			charge_bar.value = 0
	elif check_distance_to_anvil():
		spawned_anvil.show_interact_prompt()
		if Input.is_action_just_pressed("Interact"):
			holding_anvil = true
			spawned_anvil.queue_free()
	else:
		spawned_anvil.hide_interact_prompt()
	
	pull_in_nearby_mana(mana_pull_range, delta)

func check_distance_to_anvil() -> bool:
	return (spawned_anvil.global_position - global_position).length() <= interact_distance

func throw_anvil(strength, direction):
	var instance = anvil_scene.instantiate()
	instance.global_transform = global_transform
	get_parent().add_child(instance)
	var impulse = direction.normalized() * strength
	instance.apply_central_impulse(impulse)
	holding_anvil = false
	return instance

func strike_enemy(enemy):
	var hammer_instance = hammer_scene.instantiate()
	var angle_to_enemy = (enemy.global_position - global_position).angle()
	hammer_instance.global_position = enemy.global_position
	hammer_instance.global_rotation = angle_to_enemy + deg_to_rad(90)
	get_parent().add_child(hammer_instance)
	hammer_instance.swing_at_location(enemy.global_position)
	time_since_last_swing = 0.0

func get_closest_enemy_in_range(the_range):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var closest_enemy_range = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist <= the_range and dist < closest_enemy_range:
			closest_enemy = enemy
			closest_enemy_range = dist
		
	return closest_enemy

func pull_in_nearby_mana(the_range, delta):
	var mana_rocks = get_tree().get_nodes_in_group("mana_rocks")
	for mana_rock in mana_rocks:
		var dist = global_position.distance_to(mana_rock.global_position)
		if dist <= mana_min_range:
			current_exp += 1
			exp_gained.emit(current_exp, exp_for_next_level, current_level)
			mana_rock.queue_free()
		elif dist <= the_range:
			mana_rock.global_position = mana_rock.global_position.move_toward(global_position, mana_pull_speed * delta)
