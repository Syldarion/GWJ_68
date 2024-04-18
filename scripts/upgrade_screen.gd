extends Control

@export var upgrade_option_scene : PackedScene

signal upgrade_selected(name)

var option_container
var selected_option = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	option_container = $UpgradeScreenCanvasLayer/OptionContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clear_upgrade_screen():
	for option in option_container.get_children():
		option.queue_free()


func add_option_to_list(upgrade_name, upgrade_data):
	# this is just passed key/value pair from the upgrade library
	var new_option = upgrade_option_scene.instantiate()
	option_container.add_child(new_option)
	new_option.set_upgrade_name(upgrade_name)
	new_option.set_icon(upgrade_data.icon)
	new_option.set_description(upgrade_data.description)
	new_option.panel_clicked.connect(_on_upgrade_panel_clicked.bind(new_option))


func _on_upgrade_panel_clicked(upgrade_name, upgrade_panel):
	print_debug(upgrade_name)
	upgrade_selected.emit(upgrade_name)
