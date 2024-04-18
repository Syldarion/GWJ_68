extends Control

@export var FlareTexturePath : NodePath

signal panel_clicked(name)

var flare_texture
var main_panel
var upgrade_name

var zoom_tween = null
var mouse_is_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	main_panel = $UpgradeOptionControl
	main_panel.pivot_offset = main_panel.size / 2
	flare_texture = get_node(FlareTexturePath) as TextureRect
	flare_texture.pivot_offset = flare_texture.size / 2
	
	main_panel.mouse_entered.connect(_on_main_panel_mouse_entered)
	main_panel.mouse_exited.connect(_on_main_panel_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	flare_texture.rotation += deg_to_rad(90) * delta


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and mouse_is_over:
			panel_clicked.emit(upgrade_name)


func _on_main_panel_mouse_entered():
	zoom_in_main_panel()
	mouse_is_over = true


func _on_main_panel_mouse_exited():
	zoom_out_main_panel()
	mouse_is_over = false


func zoom_in_main_panel():
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "scale", Vector2.ONE * 1.1, 0.25)


func zoom_out_main_panel():
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "scale", Vector2.ONE * 1.0, 0.25)


func set_upgrade_name(new_name):
	upgrade_name = new_name


func set_icon(resource_path):
	var icon = load(resource_path)
	$UpgradeOptionControl/IconTexture.texture = icon


func set_description(desc):
	$UpgradeOptionControl/UpgradeDescription.text = desc
