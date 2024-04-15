extends Node2D

@export var spawn_data : Array[SpawnWaveData] = []
@export var entity_spawner_path : NodePath

var entity_spawner
var current_wave = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	entity_spawner = get_node(entity_spawner_path)
	
	$SpawnTimer.connect("timeout", _on_SpawnTimer_timeout)
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_SpawnTimer_timeout():
	var enemy_data = spawn_data[current_wave % spawn_data.size()]
	entity_spawner.spawn_wave_offscreen(enemy_data)
	current_wave += 1
