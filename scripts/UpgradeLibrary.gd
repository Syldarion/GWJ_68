class_name UpgradeLibary
extends Object


const UPGRADES = {
	"Hammer_Damage1": {
		"description": "Increase the hammer's attack by 10.",
		"effect": {"hammer_damage": 10},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117.png",
		"prerequisites": []
	},
	"Hammer_Damage2": {
		"description": "Increase the hammer's attack by 15.",
		"effect": {"hammer_damage": 15},
		"prerequisites": ["Hammer_Damage1"]
	},
	"Hammer_Damage3": {
		"description": "Increase the hammer's attack by 20.",
		"effect": {"hammer_damage": 20},
		"prerequisites": ["Hammer_Damage2"]
	},
	"MoveSpeed1": {
		"description": "Increase your move speed by 10%.",
		"effect": {"speed_mult": 0.1},
		"prerequisites": []
	},
	"MoveSpeed2": {
		"description": "Increase your move speed by 10%.",
		"effect": {"speed_mult": 0.1},
		"prerequisites": ["MoveSpeed2"]
	},
	"Hammer_Range1": {
		"description": "Increase the hammer's attack range by 20%",
		"effect": {"hammer_range_mult": 0.2},
		"prerequisites": []
	},
	"Hammer_Speed1": {
		"description": "Increase the hammer's attack speed by 20%",
		"effect": {"hammer_speed_mult": 0.2},
		"prerequisites": []
	}
}
