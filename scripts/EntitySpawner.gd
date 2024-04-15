extends Node2D

@export var spawner_list : Dictionary
@export var entity_parent_node : NodePath
@export var offscreen_spawn_distance : float

var entity_parent


# Called when the node enters the scene tree for the first time.
func _ready():
	entity_parent = get_node(entity_parent_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_wave_offscreen(spawn_data: SpawnWaveData):
	for i in range(spawn_data.enemy_count):
		var rand_angle = randf_range(0.0, 2 * PI)
		var loc_offscreen = Vector2(cos(rand_angle), sin(rand_angle)) * offscreen_spawn_distance
		spawn_entity(spawn_data.enemy_name, loc_offscreen)


func spawn_entity(entity_name, spawn_loc):
	var instance = spawner_list[entity_name].instantiate()
	instance.global_position = spawn_loc
	get_parent().add_child(instance)
	return instance
