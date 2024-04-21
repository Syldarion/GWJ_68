extends Control

@export var game_scene : PackedScene
@export var howto_slides : Array[Resource]

@onready var master_bus = AudioServer.get_bus_index("Master")
@onready var sfx_bus = AudioServer.get_bus_index("SFX")
@onready var music_bus = AudioServer.get_bus_index("Music")

var how_to_slide_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$SettingsOptions/MusicVolumeSlider.value = SettingsController.music_volume_percent
	$SettingsOptions/SFXVolumeSlider.value = SettingsController.sfx_volume_percent
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(SettingsController.music_volume_percent))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(SettingsController.sfx_volume_percent))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_game():
	get_tree().change_scene_to_packed(game_scene)


func _on_start_game_button_pressed():
	start_game()


func _on_music_volume_slider_drag_ended(value_changed):
	if value_changed:
		SettingsController.music_volume_percent = $SettingsOptions/MusicVolumeSlider.value
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(SettingsController.music_volume_percent))


func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		SettingsController.sfx_volume_percent = $SettingsOptions/SFXVolumeSlider.value
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(SettingsController.sfx_volume_percent))


func _on_settings_back_button_pressed():
	$SettingsOptions.hide()
	$MenuButtons.show()


func _on_settings_button_pressed():
	$MenuButtons.hide()
	$SettingsOptions.show()


func _on_how_to_play_button_pressed():
	$HowToControl.show()
	$MenuButtons.hide()


func _on_next_slide_button_pressed():
	how_to_slide_index += 1
	$HowToControl/TextureRect.texture = howto_slides[how_to_slide_index % 4]


func _on_previous_slide_button_pressed():
	how_to_slide_index -= 1
	$HowToControl/TextureRect.texture = howto_slides[how_to_slide_index % 4]


func _on_how_to_back_button_pressed():
	$HowToControl.hide()
	$MenuButtons.show()
