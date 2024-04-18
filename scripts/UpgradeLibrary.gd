class_name UpgradeLibary
extends Object


const UPGRADES = {
	"Hammer_Damage1": {
		"description": "Increase the hammer's attack by 10.",
		"effect": {"hammer_damage_add": 10},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": []
	},
	"Hammer_Damage2": {
		"description": "Increase the hammer's attack by 15.",
		"effect": {"hammer_damage_add": 15},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": ["Hammer_Damage1"]
	},
	"Hammer_Damage3": {
		"description": "Increase the hammer's attack by 20.",
		"effect": {"hammer_damage_add": 20},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": ["Hammer_Damage2"]
	},
	"MoveSpeed1": {
		"description": "Increase your move speed by 20%.",
		"effect": {"speed_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": []
	},
	"MoveSpeed2": {
		"description": "Increase your move speed by 20%.",
		"effect": {"speed_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": ["MoveSpeed1"]
	},
	"Hammer_Range1": {
		"description": "Increase the hammer's attack range by 20%",
		"effect": {"hammer_range_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": []
	},
	"Hammer_Speed1": {
		"description": "Increase the hammer's attack speed by 20%",
		"effect": {"hammer_speed_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": []
	}
}
