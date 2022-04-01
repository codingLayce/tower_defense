extends Node

const _GameState: = preload("res://Scenes/Maps/GameState.gd")

onready var towers_container: = get_node("Towers")
onready var path_node: = get_node("Path")

onready var state: _GameState = _GameState.new()

# -------------------- CALLBACKS --------------------

func _ready() -> void:
	state.connect("wave_changed", self, "_on_wave_changed")
	state.start_wave()

# -------------------- WAVE --------------------

func _on_wave_changed(wave: int) -> void:
	spawn_enemies()

func spawn_enemies() -> void:
	for enemy in state.wave_data:
		var new_enemy = GameData.get_enemy_from_id(enemy[0]).instance()
		path_node.add_child(new_enemy, true)
		yield(get_tree().create_timer(enemy[1]), "timeout")

# -------------------- BUILD --------------------

func build_tower(tower: PackedScene, position: Vector2) -> void:
	var new_tower = tower.instance()
	new_tower.position = position
	new_tower.set_name(new_tower.get_name() + "_1")
	
	towers_container.add_child(new_tower, true)
