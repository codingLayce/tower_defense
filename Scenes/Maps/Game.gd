extends Node

const _GameState: = preload("res://Scenes/Maps/GameState.gd")

onready var towers_container: = get_node("Towers")
onready var path_node: = get_node("Path")
onready var ui_node: = get_node("UI")
onready var camera: Camera2D = get_node("Camera2D")

onready var state: _GameState = _GameState.new()

# -------------------- CALLBACKS --------------------

func _ready() -> void:
	state.connect("wave_changed", self, "_on_wave_changed")
	state.connect("wave_ended", self, "_on_wave_ended")
	state.connect("health_changed", ui_node, "on_health_changed")
	state.connect("game_ended", self, "_on_game_ended")
	
	ui_node.on_wave_changed(state.current_wave, state.max_waves)

# -------------------- SIGNALS --------------------

func on_enemy_hit_base() -> void:
	camera.shake(50)
	state.on_enemy_hit_base()

# -------------------- WAVE --------------------

func _on_game_ended(result: bool) -> void:
	# TODO : Display endgame screen
	get_tree().change_scene("res://Scenes/UIScenes/MainScene.tscn")

func _on_wave_ended() -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	state.next_wave()

func _on_wave_changed(wave: int) -> void:
	ui_node.on_wave_changed(wave, state.max_waves)
	spawn_enemies()

func spawn_enemies() -> void:
	for enemy in state.wave_data:
		var new_enemy = GameData.get_enemy_from_id(enemy[0]).instance()
		new_enemy.connect("die", state, "on_enemy_die")
		new_enemy.connect("base_hit", self, "on_enemy_hit_base")
		path_node.add_child(new_enemy, true)
		yield(get_tree().create_timer(enemy[1]), "timeout")

# -------------------- BUILD --------------------

func build_tower(tower: PackedScene, position: Vector2) -> void:
	var new_tower = tower.instance()
	new_tower.position = position
	new_tower.set_name(new_tower.get_name() + "_1")
	new_tower.activated = true
	
	towers_container.add_child(new_tower, true)
