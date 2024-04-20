extends Camera2D

@export var FollowTarget : NodePath
@export var FollowBoundingBox : Rect2
@export var FollowSpeed : float = 0.1
@export var SnapFollowSpeed : float = 20.0

@export var DefaultZoom : float = 3.0
@export var FocusZoom : float = 6.0
@export var ZoomTime : float = 3.0

@export var ShakeDecay : float = 0.8
@export var MaxShakeOffset : Vector2

var shake_trauma = 0.0
var shake_trauma_power = 2

var focus_mode = false
var target : Node
var zoom_tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not has_node(FollowTarget):
		print_debug("INVALID FOLLOW TARGET")
		return
	target = get_node(FollowTarget)


func enter_focus_zoom():
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", Vector2.ONE * FocusZoom, ZoomTime)
	focus_mode = true

func leave_focus_zoom():
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", Vector2.ONE * DefaultZoom, ZoomTime)
	focus_mode = false

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
	
	if shake_trauma:
		shake_trauma = max(shake_trauma - ShakeDecay * delta, 0.0)
		shake()


func add_trauma(amount):
	shake_trauma = min(shake_trauma + amount, 1.0)


func shake():
	var amount = pow(shake_trauma, shake_trauma_power)
	offset.x = MaxShakeOffset.x * amount * randf_range(-1.0, 1.0)
	offset.y = MaxShakeOffset.y * amount * randf_range(-1.0, 1.0)
