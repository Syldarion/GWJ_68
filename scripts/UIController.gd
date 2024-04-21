extends Control


var exp_bar : TextureProgressBar
var exp_label : Label
var hp_bar : TextureProgressBar
var hp_label : Label
var game_timer_label : Label
var kill_count_label : Label


# Called when the node enters the scene tree for the first time.
func _ready():
	exp_bar = $CanvasLayer/EXPBar
	exp_label = $CanvasLayer/EXPBar/LevelLabel
	hp_bar = $CanvasLayer/HPBar
	hp_label = $CanvasLayer/HPBar/HPLabel
	game_timer_label = $CanvasLayer/CenterContainer/GameTimerLabel
	kill_count_label = $CanvasLayer/KillCountLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_exp_bar_values(min_val, max_val, current, level):
	exp_bar.min_value = min_val
	exp_bar.max_value = max_val
	exp_bar.value = current
	exp_label.text = str(level)


func set_hp_bar_values(min_val, max_val, current):
	hp_bar.min_value = min_val
	hp_bar.max_value = max_val
	hp_bar.value = current
	hp_label.text = str(current)


func set_timer_text(new_text):
	game_timer_label.text = new_text


func set_kill_count_text(new_text):
	kill_count_label.text = new_text
