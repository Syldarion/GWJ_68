extends RigidBody2D


var anvil_damage = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_RigidBody2D_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_damage(dmg):
	anvil_damage = dmg


func _on_RigidBody2D_body_entered(body):
	if body.is_in_group("enemies"):
		call_deferred("_freeze_anvil")
		body.damage_entity(anvil_damage)
		body.knockback_entity((body.global_position - global_position).normalized() * linear_velocity.length())

func _freeze_anvil():
	freeze = true

func show_interact_prompt():
	$InteractSprite.visible = true

func hide_interact_prompt():
	$InteractSprite.visible = false
