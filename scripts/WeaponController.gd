extends Node2D

@onready var animation_player = $AnimationPlayer as AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func swing_at_location(location):
	animation_player.play("swing")
	animation_player.connect("animation_finished", _on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "swing":
		queue_free()
