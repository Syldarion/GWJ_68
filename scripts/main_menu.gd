extends Control

@export var game_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_game():
	get_tree().change_scene_to_packed(game_scene)


func _on_start_game_button_pressed():
	start_game()
