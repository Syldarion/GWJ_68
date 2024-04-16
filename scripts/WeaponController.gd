extends Node2D

@export_category("Weapon Stats")
@export var weapon_damage : int

@onready var weapon_body = $WeaponBody as Area2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_body.connect("body_entered", _on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Line2D.points[0] = weapon_body.position


func swing_at_location(location):
	animation_player.play("swing")
	animation_player.connect("animation_finished", _on_animation_finished)


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.damage_entity(weapon_damage)


func _on_animation_finished(anim_name):
	if anim_name == "swing":
		queue_free()
