extends Camera2D

@export var FollowTarget : NodePath
@export var FollowBoundingBox : Rect2
@export var FollowSpeed : float = 0.1
@export var SnapFollowSpeed : float = 20.0

var target : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if not has_node(FollowTarget):
		print_debug("INVALID FOLLOW TARGET")
		return
	target = get_node(FollowTarget)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not target:
		return
	
	var tar_rel_pos = target.global_position - global_position
	
	if not FollowBoundingBox.has_point(to_local(target.global_position)):
		var desired_pos = global_position
		
		if tar_rel_pos.x < FollowBoundingBox.position.x:
			desired_pos.x += tar_rel_pos.x - FollowBoundingBox.position.x
		elif tar_rel_pos.x > FollowBoundingBox.position.x + FollowBoundingBox.size.x:
			desired_pos.x += tar_rel_pos.x - (FollowBoundingBox.position.x + FollowBoundingBox.size.x)
		
		if tar_rel_pos.y < FollowBoundingBox.position.y:
			desired_pos.y += tar_rel_pos.y - FollowBoundingBox.position.y
		elif tar_rel_pos.y > FollowBoundingBox.position.y + FollowBoundingBox.size.y:
			desired_pos.y += tar_rel_pos.y - (FollowBoundingBox.position.y + FollowBoundingBox.size.y)
		
		global_position = global_position.lerp(desired_pos, SnapFollowSpeed * delta)
	else:
		global_position = global_position.lerp(target.global_position, FollowSpeed * delta)
