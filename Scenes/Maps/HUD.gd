extends CanvasLayer

const gunt1_type: String = "GunT1"

const _GunT1: = preload("res://Scenes/Towers/GunT1.tscn")
const _RangeVisualizer: = preload("res://Scenes/Supports/RangeVisualizer.tscn")

const invalid_color: Color = Color("ff0000")
const valid_color: Color = Color("00ff00")

onready var map: = get_parent()
onready var entities_tile: = map.get_node("Entities")
onready var life_lbl: Label = get_node("HUD/InformationPanel/VBox/LifeBar/Life")
onready var waves_lbl: Label = get_node("HUD/WavesContainer/Waves")
onready var money_lbl: Label = get_node("HUD/InformationPanel/VBox/MoneyBar/Money")
onready var tower_tooltip: Popup = get_node("HUD/TowerInformation")

var build_mode: bool = false
var preview_position: Vector2 = Vector2.ZERO
var tower_type: String = ""

# -------------------- CALLBACKS --------------------

func _process(delta: float) -> void:
	if build_mode:
		update_preview()

func _input(event: InputEvent) -> void:
	if build_mode:
		handle_build_input(event)
		
func _draw() -> void:
	if build_mode:
		draw_range_preview()

# -------------------- SIGNALS --------------------

func _on_BtnGunT1_mouse_exited():
	tower_tooltip.hide()

func _on_BtnGunT1_mouse_entered():
	var gunT1 = GameData.towers_data["GunT1"]
	tower_tooltip.on_create("GunT1", gunT1.cost, gunT1.damage, gunT1.rof)
	tower_tooltip.show()

func on_money_changed(money: int) -> void:
	money_lbl.text = str(money)

func on_wave_changed(wave: int, max_wave: int) -> void:
	waves_lbl.text = "%d / %d" % [wave, max_wave]

func on_health_changed(health: int) -> void:
	life_lbl.text = str(health)

func _on_BtnGunT1_pressed() -> void:
	if build_mode:
		cancel_build()
	start_build_mode(gunt1_type)

func _on_BtnPlayPause_pressed() -> void:
	var is_paused = get_tree().paused
	
	if build_mode:
		cancel_build()
	
	if not is_paused and map.state.current_wave == 0:
		map.state.next_wave()
		return
		
	get_tree().paused = not is_paused

func _on_BtnSpeedUp_pressed() -> void:
	if Engine.time_scale == 1.0:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0

# -------------------- BUILD --------------------

func get_tower_scene() -> PackedScene:
	match tower_type:
		gunt1_type:
			return _GunT1
	return null

func draw_range_preview() -> void:
	pass

func handle_build_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		place_build()
	elif event.is_action_released("ui_cancel"):
		cancel_build()

func update_preview() -> void:
	var preview = get_node("Preview")
	preview_position = calculate_preview_position()
	var is_position_valid = is_position_valid()
	
	if is_position_valid && preview.modulate == invalid_color:
		preview.modulate = valid_color
	elif not is_position_valid && preview.modulate == valid_color:
		preview.modulate = invalid_color
	
	preview.position = preview_position

func place_build() -> void:
	if is_position_valid():
		map.build_tower(get_tower_scene(), calculate_preview_position())
	cancel_build()

func is_position_valid() -> bool:
	var tile_pos = entities_tile.world_to_map(preview_position)
	if tile_pos.x < 3:
		return false
	return entities_tile.get_cellv(tile_pos) == -1

func calculate_preview_position() -> Vector2:
	var mouse_position = map.get_global_mouse_position()
	var tile_position = entities_tile.world_to_map(mouse_position)
	return entities_tile.map_to_world(tile_position)

func start_build_mode(tower: String) -> void:
	tower_type = tower
	build_mode = true
	
	var range_preview = _RangeVisualizer.instance()
	range_preview.radius = GameData.towers_data[tower].range
	
	var preview = _GunT1.instance()
	preview.set_name("Preview")
	preview.position = calculate_preview_position()
	preview.modulate = invalid_color
	preview.add_child(range_preview)
	add_child(preview)

func cancel_build() -> void:
	get_node("Preview").free()
	build_mode = false
