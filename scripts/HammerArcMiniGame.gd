extends Node2D

signal hammer_struck(strike_value)
signal minigame_done(final_value)

var sweet_spot_size = 15

var arc_radius = 32

var no_effect_color = Color(1, 0, 0)
var med_effect_color = Color(1, 1, 0)
var sweet_spot_color = Color(0, 1, 0)


var pointer_position = 0
var swinging_right = true
var swing_speed = 200
var pointer_radius = 24


var hit_cooldown = 0.5
var time_since_hit = 0.5

var sweet_spot_value_add = 0.05
var med_effect_value_add = 0.01
var no_effect_value_add = 0.0
var minigame_value = 0
var max_strikes = 3
var strike_count = 0

var start_rad = deg_to_rad(0)
var end_rad = deg_to_rad(90)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if swinging_right:
		pointer_position = min(pointer_position + swing_speed * delta, 90)
		if pointer_position >= 90:
			swinging_right = false
	else:
		pointer_position = max(pointer_position - swing_speed * delta, 0)
		if pointer_position <= 0:
			swinging_right = true
	
	queue_redraw()
	
	if Input.is_action_just_pressed("StrikeAnvil") and time_since_hit >= hit_cooldown:
		hit_anvil()
	
	time_since_hit += delta


func _draw():
	# draw the no effect zome
	draw_arc(Vector2.ZERO, arc_radius, start_rad, end_rad - deg_to_rad(sweet_spot_size), 8, no_effect_color, 4)
	# draw the sweet spot
	draw_arc(Vector2.ZERO, arc_radius, end_rad - deg_to_rad(sweet_spot_size), end_rad, 8, sweet_spot_color, 4)
	
	# draw_circle(Vector2(cos(deg_to_rad(pointer_position)), sin(deg_to_rad(pointer_position))) * pointer_radius, 2.0, Color.WHITE)
	var angle = deg_to_rad(pointer_position)
	var base_point = Vector2(cos(angle), sin(angle))
	
	draw_line(base_point * 24, base_point * 32, Color.WHITE, 2.0)


func hit_anvil():
	$AudioStreamPlayer.play()
	
	if pointer_position > (90 - sweet_spot_size):
		# sweet spot hit
		minigame_value += sweet_spot_value_add
		hammer_struck.emit(sweet_spot_value_add)
	else:
		# no effect hit
		minigame_value += no_effect_value_add
		hammer_struck.emit(no_effect_value_add)
	
	time_since_hit = 0
	strike_count += 1
	
	if strike_count >= max_strikes:
		minigame_done.emit(minigame_value)
