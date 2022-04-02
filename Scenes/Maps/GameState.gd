extends Node
class_name GameState

signal wave_changed(number)
signal wave_ended()
signal game_ended(result)

signal health_changed(health)

var current_wave: int = 0
var max_waves: int = 2
var enemies_left: int = 0
var wave_data: Array = []

var health: int = 10

# -------------------- LISTENERS --------------------

func on_enemy_hit_base() -> void:
	health -= 1
	emit_signal("health_changed", health)
	
	if health == 0:
		emit_signal("game_ended", false)

func on_enemy_die() -> void:
	enemies_left -= 1
	
	if enemies_left == 0:
		if current_wave == max_waves:
			emit_signal("game_ended", true)
		else:
			emit_signal("wave_ended")

# -------------------- WAVES --------------------

func next_wave() -> void:
	current_wave += 1
	wave_data = load_wave()
	enemies_left = wave_data.size()
	emit_signal("wave_changed", current_wave)

func load_wave() -> Array:
	return GameData.waves[current_wave-1]
