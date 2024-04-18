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
	var player_node = get_tree().get_first_node_in_group("player")
	var min_angle = 0.0
	var max_angle = 2 * PI
	for i in range(spawn_data.enemy_count):
		var rand_angle = randf_range(min_angle, max_angle)
		var loc_offscreen = player_node.global_position + Vector2(cos(rand_angle), sin(rand_angle)) * offscreen_spawn_distance
		spawn_enemy(spawn_data.enemy_name, loc_offscreen)


func spawn_enemy(enemy_name, spawn_loc):
	var enemy = spawn_entity(enemy_name, spawn_loc) as EnemyController
	enemy.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(death_loc):
	spawn_entity("manarock", death_loc)


func spawn_entity(entity_name, spawn_loc):
	var instance = spawner_list[entity_name].instantiate()
	instance.global_position = spawn_loc
	entity_parent.add_child(instance)
	return instance
