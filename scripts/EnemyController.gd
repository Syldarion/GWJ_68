class_name EnemyController
extends CharacterBody2D

@export var move_speed : float = 20.0
@export var max_health : int = 100
@export var attack_range : float = 8
@export var attack_cooldown : float = 2.0
@export var attack_damage : int = 10
@export var attack_scene : PackedScene

@onready var health_bar = $HealthBar as TextureProgressBar

signal enemy_died(location)

var current_health
var player_target

var time_since_last_attack = 0

var knockback_duration = 0.25
var knockback_timer = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	
	player_target = get_tree().get_first_node_in_group("player")
	
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_bar.visible = false
	
	current_health = max_health


func set_health(current, max_hp):
	max_health = max_hp
	current_health = current
	
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = current_health


func _physics_process(delta):
	if knockback_timer > 0:
		knockback_timer -= delta
	elif player_target:
		var distance_to_player = global_position.distance_to(player_target.global_position)
		if distance_to_player > attack_range:
			var movement_dir = (player_target.global_position - global_position).normalized()
			velocity = movement_dir * move_speed
		else:
			velocity = Vector2.ZERO
	move_and_collide(velocity * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance_to_player = global_position.distance_to(player_target.global_position)
	time_since_last_attack += delta
	if time_since_last_attack > attack_cooldown and distance_to_player <= attack_range:
		attack_player()


func attack_player():
	time_since_last_attack = 0
	var new_attack = attack_scene.instantiate()
	add_child(new_attack)
	var attack_target = player_target.global_position + Vector2.UP * 8
	new_attack.global_rotation = (attack_target - global_position).angle() + deg_to_rad(90)
	new_attack.swing_at_location(attack_target)


func damage_entity(damage_amount):
	
	current_health = max(current_health - damage_amount, 0)
	health_bar.value = current_health
	health_bar.visible = true
	if current_health <= 0:
		enemy_died.emit(global_position)
		queue_free()

func knockback_entity(knock_velocity):
	velocity = knock_velocity
	knockback_timer = knockback_duration
