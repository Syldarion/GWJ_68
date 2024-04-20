extends Node2D

signal shockwave_hit_enemy(entity_hit)

var radius = 0
var wave_damage = 0
var knockback_force = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShockwaveArea.connect("body_entered", _on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ShockwaveArea/CollisionShape2D.shape.radius = radius
	queue_redraw()


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.damage_entity(wave_damage)
		body.knockback_entity((body.global_position - global_position).normalized() * knockback_force)
		shockwave_hit_enemy.emit(body)


func _draw():
	draw_arc(Vector2.ZERO, radius, 0, 2 * PI, 64, Color(1, 1, 1, 0.4), 2.0, true)


func shockwave(distance, speed, damage, force):
	# each single number of horizontal scale is 8px
	var target_horiz = distance / 8
	var target_zoom = Vector2(target_horiz, target_horiz / 2)
	# speed should be pixels per second
	# tween receives TOTAL time (also in seconds)
	# so it's just distance / speed, duh
	
	radius = 0
	wave_damage = damage
	knockback_force = force
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "radius", distance, distance / speed)
	# scale_tween.tween_property($ShockwaveSprite, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	# scale_tween.tween_property($ShockwaveSprite, "modulate:a", 0, 0.05)
	scale_tween.tween_callback(queue_free)
