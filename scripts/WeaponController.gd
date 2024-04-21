extends Node2D

@export_category("Weapon Stats")
@export var base_weapon_damage : int
@export var harm_group : String
@export var strike_anim_name : String

@onready var weapon_body = $WeaponBody as Area2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

var damage_modifier = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_body.connect("body_entered", _on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Line2D.points[0] = weapon_body.position


func swing_at_location(location):
	animation_player.play(strike_anim_name)
	animation_player.connect("animation_finished", _on_animation_finished)


func _on_body_entered(body):
	if body.is_in_group(harm_group):
		body.damage_entity(base_weapon_damage + damage_modifier)


func _on_animation_finished(anim_name):
	if anim_name == strike_anim_name:
		queue_free()
