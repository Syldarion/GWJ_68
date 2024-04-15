extends Node2D

@export var spawner_list : Dictionary
@export var entity_parent_node : NodePath

var entity_parent


# Called when the node enters the scene tree for the first time.
func _ready():
	entity_parent = get_node(entity_parent_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_entity(entity_name, spawn_loc):
	var instance = spawner_list[entity_name].instantiate()
	instance.global_position = spawn_loc
	get_parent().add_child(instance)
	return instance
