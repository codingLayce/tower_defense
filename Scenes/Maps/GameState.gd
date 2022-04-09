extends Node
class_name GameState

signal wave_changed(number)
signal wave_ended()
signal game_ended(result)

signal health_changed(health)

signal money_changed(money)

var current_wave: int = 0
var max_waves: int = 5
var enemies_left: int = 0
var wave_data: Array = []

var health: int = 10

var money: int = 500

# -------------------- LISTENERS --------------------

func on_tower_build_request(cost: int) -> bool:
	if money - cost >= 0:
		money -= cost
		emit_signal("money_changed", money)
		return true
	return false

func on_enemy_hit_base() -> void:
	health -= 1
	emit_signal("health_changed", health)
	
	if health == 0:
		emit_signal("game_ended", false)

func on_enemy_die(reward: int) -> void:
	enemies_left -= 1
	money += reward
	emit_signal("money_changed", money)
	
	if enemies_left == 0:
		if current_wave == max_waves:
			emit_signal("game_ended", true)
		else:
			emit_signal("wave_ended")

# -------------------- WAVES --------------------

func next_wave() -> void:
	current_wave += 1
	wave_data = load_wave()
	enemies_left = count_wave_enemies()
	emit_signal("wave_changed", current_wave)

func count_wave_enemies() -> int:
	var count = 0
	for i in wave_data:
		count += i[1]
	return count

func load_wave() -> Array:
	return GameData.waves[current_wave-1]
