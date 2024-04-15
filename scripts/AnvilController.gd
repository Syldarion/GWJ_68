extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_RigidBody2D_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_RigidBody2D_body_entered(body):
	print_debug("Hit Something")
	call_deferred("_freeze_anvil")
	if body.is_in_group("enemies"):
		print_debug("Hit an Enemy")
		body.damage_entity(60)

func _freeze_anvil():
	freeze = true
