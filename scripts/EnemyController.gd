extends Node2D

@export var move_speed : float = 20.0
@export var max_health : int = 100

@onready var health_bar = $HealthBar as TextureProgressBar

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_target:
		global_position = global_position.move_toward(player_target.global_position, move_speed * delta)


func damage_entity(damage_amount):
	current_health = max(current_health - damage_amount, 0)
	health_bar.value = current_health
	health_bar.visible = true
	if current_health <= 0:
		# TODO: send a signal for death
		queue_free()

func knockback_entity(knock_velocity):
	global_position += knock_velocity
