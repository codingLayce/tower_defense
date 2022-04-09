extends Node

const _TankT1: = preload("res://Scenes/Tanks/TankT1.tscn")
const _TankT2: = preload("res://Scenes/Tanks/TankT2.tscn")
const _TankT3: = preload("res://Scenes/Tanks/TankT3.tscn")
const _TankT4: = preload("res://Scenes/Tanks/TankT4.tscn")

var waves = [
	[[1, 10]],
	[[1, 16]],
	[[1, 13], [2, 3]],
	[[1, 17], [2, 9]],
	[[1, 5], [2, 14]]
]

var towers_data = {
	"GunT1": {
		"range": 200,
		"rof": 0.5,
		"damage": 50,
		"cost": 200
	}
}

var tanks_data = {
	"TankT1": {
		"speed": 150,
		"health": 100
	},
	"TankT2": {
		"speed": 150,
		"health": 150
	}
}

func get_enemy_from_id(index: int) -> PackedScene:
	match index:
		1: return _TankT1
		2: return _TankT2
		3: return _TankT3
		4: return _TankT4
	return null
