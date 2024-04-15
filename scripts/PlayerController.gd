extends Node2D

@export var player_speed = 40
@export var throw_charge_buildup = 2
@export var max_throw_charge = 500

@onready var hammer = $TheHammer
@onready var charge_bar = $ChargeBar as TextureProgressBar

var anvil_scene = preload("res://scenes/the_anvil.tscn")

var throw_charge = 0
var holding_anvil = true
var spawned_anvil = null

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
	
	translate(movement * player_speed * delta)
	
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
	
	var mouse_pos = get_local_mouse_position()
	var angle = mouse_pos.angle()
	move_hammer(angle)

func throw_anvil(strength, direction):
	var instance = anvil_scene.instantiate()
	instance.global_transform = global_transform
	get_parent().add_child(instance)
	var impulse = direction.normalized() * strength
	instance.apply_central_impulse(impulse)
	holding_anvil = false
	return instance

func move_hammer(angle):
	var angle_deg = rad_to_deg(angle)
	hammer.rotation = angle + deg_to_rad(90)
	hammer.position.x = cos(angle) * 32
	hammer.position.y = sin(angle) * 32
