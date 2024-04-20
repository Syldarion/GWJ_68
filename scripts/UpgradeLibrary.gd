class_name UpgradeLibrary
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
	"Hammer_Range2": {
		"description": "Increase the hammer's attack range by 20%",
		"effect": {"hammer_range_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": ["Hammer_Range1"]
	},
	"Hammer_Speed1": {
		"description": "Increase the hammer's attack speed by 20%",
		"effect": {"hammer_speed_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": []
	},
	"Hammer_Speed2": {
		"description": "Increase the hammer's attack speed by 20%",
		"effect": {"hammer_speed_mult": 0.2},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0117_silhouette.png",
		"prerequisites": ["Hammer_Speed1"]
	},
	"Anvil_Damage1": {
		"description": "Increase the anvil's damage by 10.",
		"effect": {"anvil_damage_add": 10},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0074_silhouette.png",
		"prerequisites": []
	},
	"Anvil_ShockwaveDamage1": {
		"description": "Increase the anvil's shockwave damage by 10.",
		"effect": {"anvil_shockwave_damage_add": 10},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0074_silhouette.png",
		"prerequisites": []
	},
	"IncreasedHealth1": {
		"description": "Increase your health by 50.",
		"effect": {"health": 50},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": []
	},
	"IncreasedHealth2": {
		"description": "Increase your health by 50.",
		"effect": {"health": 50},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": ["IncreasedHealth1"]
	},
	"IncreasedDodgeChance1": {
		"description": "Increase your dodge chance by 5%",
		"effect": {"dodge_chance": 0.05},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": []
	},
	"IncreasedDodgeChance2": {
		"description": "Increase your dodge chance by 5%",
		"effect": {"dodge_chance": 0.05},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": ["IncreasedDodgeChance1"]
	},
	"IncreasedEXPGain1": {
		"description": "Increase the amount of EXP gained by 5%",
		"effect": {"exp_mult": 0.05},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": []
	},
	"IncreasedEXPGain2": {
		"description": "Increase the amount of EXP gained by 5%",
		"effect": {"exp_mult": 0.05},
		"icon": "res://sprites/kenney/tiny-dungeon/tile_0086_silhouette.png",
		"prerequisites": ["IncreasedEXPGain1"]
	},
	"__UPGRADE_TEMPLATE__": {
		"description": "",
		"effect": {},
		"icon": "",
		"prerequisites": ["__UPGRADE_TEMPLATE__"]
	},
}
