extends Control


var exp_bar : TextureProgressBar
var exp_label : Label
var hp_bar : TextureProgressBar
var hp_label : Label
var game_timer_label : Label
var kill_count_label : Label

var is_paused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	exp_bar = $CanvasLayer/EXPBar
	exp_label = $CanvasLayer/EXPBar/LevelLabel
	hp_bar = $CanvasLayer/HPBar
	hp_label = $CanvasLayer/HPBar/HPLabel
	game_timer_label = $CanvasLayer/CenterContainer/GameTimerLabel
	kill_count_label = $CanvasLayer/KillCountLabel
	
	$CanvasLayer/PauseMenu/VBox/MusicVolumeSlider.value = SettingsController.music_volume_percent
	$CanvasLayer/PauseMenu/VBox/SFXVolumeSlider.value = SettingsController.sfx_volume_percent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		if is_paused:
			unpause_game()
		else:
			pause_game()


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


func pause_game():
	get_tree().paused = true
	is_paused = true
	$CanvasLayer/PauseMenu.show()


func unpause_game():
	get_tree().paused = false
	is_paused = false
	$CanvasLayer/PauseMenu.hide()


func _on_music_volume_slider_drag_ended(value_changed):
	if value_changed:
		SettingsController.music_volume_percent = $CanvasLayer/PauseMenu/VBox/MusicVolumeSlider.value
		var music_bus = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(SettingsController.music_volume_percent))


func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		SettingsController.sfx_volume_percent = $CanvasLayer/PauseMenu/VBox/SFXVolumeSlider.value
		var sfx_bus = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(SettingsController.sfx_volume_percent))


func _on_resume_button_pressed():
	unpause_game()


func _on_pause_button_pressed():
	pause_game()
