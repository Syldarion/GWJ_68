class_name EnemyController
extends CharacterBody2D

@export var move_speed : float = 20.0
@export var max_health : int = 100

@onready var health_bar = $HealthBar as TextureProgressBar

signal enemy_died(location)

var current_health
var player_target


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	
	player_target = get_tree().get_first_node_in_group("player")
	
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_bar.visible = false
	
	current_health = max_health


func _physics_process(delta):
	if player_target:
		var movement_dir = (player_target.global_position - global_position).normalized()
		move_and_collide(movement_dir * move_speed * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func damage_entity(damage_amount):
	current_health = max(current_health - damage_amount, 0)
	health_bar.value = current_health
	health_bar.visible = true
	if current_health <= 0:
		enemy_died.emit(global_position)
		queue_free()

func knockback_entity(knock_velocity):
	global_position += knock_velocity
