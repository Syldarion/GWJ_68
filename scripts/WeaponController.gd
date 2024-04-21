extends Node2D

@export_category("Weapon Stats")
@export var base_weapon_damage : int
@export var harm_group : String
@export var strike_anim_name : String
@export var is_projectile : bool
@export var projectile_speed : float

@onready var weapon_body = $WeaponBody
@onready var animation_player = $AnimationPlayer as AnimationPlayer

var damage_modifier = 0
var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_body.connect("body_entered", _on_body_entered)
	if is_projectile:
		add_to_group("projectile")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Line2D.points[0] = weapon_body.position
	if is_projectile:
		var dir_to_target = (target_position - global_position).normalized()
		global_position += dir_to_target * projectile_speed * delta
		if global_position.distance_to(target_position) < 1:
			queue_free()


func swing_at_location(location):
	if strike_anim_name:
		animation_player.play(strike_anim_name)
		animation_player.connect("animation_finished", _on_animation_finished)
	if is_projectile:
		target_position = location


func _on_body_entered(body):
	if body.is_in_group(harm_group):
		body.damage_entity(base_weapon_damage + damage_modifier)


func _on_animation_finished(anim_name):
	if anim_name == strike_anim_name:
		queue_free()
