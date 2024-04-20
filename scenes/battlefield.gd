extends Node2D


@export var tilemap_scene : PackedScene
@export var tile_size : int = 3
@export var tilemap_size : Vector2

var tilemap_parent

var north_extent
var south_extent
var west_extent
var east_extent

var player_target

var tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap_parent = $TileMapParent
	player_target = get_tree().get_first_node_in_group("player")
	spawn_tilemaps()


func spawn_tilemaps():
	# okay, tilemap pivot is the center, so TOTAL width is 3x tilemap width (take a half off for left and right)
	# same for height
	
	tiles = []
	var map_size = tilemap_size * (tile_size - 1)
	var half_size = map_size / 2
	var top_left = -half_size
	# i, j -> x, y
	for i in range(tile_size):
		tiles.append([])
		for j in range(tile_size):
			var spawn_position = top_left + Vector2(i * tilemap_size.x, j * tilemap_size.y)
			var new_tilemap = tilemap_scene.instantiate()
			tilemap_parent.add_child(new_tilemap)
			new_tilemap.position = spawn_position
			tiles[i].append(new_tilemap)
	
	north_extent = -half_size.y
	south_extent = half_size.y
	west_extent = -half_size.x
	east_extent = half_size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_target.global_position.y < north_extent:
		# move the southern-most tiles to the top
		# for tile size 3
		# [0, 2], [1, 2], [2. 2]
		tilemap_parent.global_position.y -= tilemap_size.y
		north_extent -= tilemap_size.y
	elif player_target.global_position.y > south_extent:
		# move the northern-most tiles to the bottom
		tilemap_parent.global_position.y += tilemap_size.y
		south_extent += tilemap_size.y
	elif player_target.global_position.x < west_extent:
		# move the eastern-most tiles to the west
		tilemap_parent.global_position.x -= tilemap_size.x
		west_extent -= tilemap_size.x
	elif player_target.global_position.x > east_extent:
		# move the western-most tiles to the east
		tilemap_parent.global_position.x += tilemap_size.x
		east_extent += tilemap_size.x
