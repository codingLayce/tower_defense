extends Node
class_name GameState

signal wave_changed(number)

var current_wave: int = 0
var max_waves: int = 11
var enemies_left: int = 0
var wave_data: Array = []

var health: int = 10

func start_wave() -> void:
	current_wave += 1
	wave_data = load_wave()
	emit_signal("wave_changed", current_wave)

func load_wave() -> Array:
	return GameData.waves[current_wave-1]
