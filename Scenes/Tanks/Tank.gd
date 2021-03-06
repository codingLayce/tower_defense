extends PathFollow2D

signal base_hit()
signal die(reward)

const _Impact: = preload("res://Scenes/Effects/Impact.tscn")
const _Explosion: = preload("res://Scenes/Effects/Explosion.tscn")

onready var impact_pos_node: Position2D = get_node("ImpactPos")

var speed: int = 150
var health: int = 100
var reward: int = 1

var tank_type: String = "TankT1"

# ---------- CALLBACKS ----------

func _ready() -> void:
	health = GameData.tanks_data[tank_type].health
	speed = GameData.tanks_data[tank_type].speed
	reward = GameData.tanks_data[tank_type].reward

func _physics_process(delta: float) -> void:
	move(delta)
	check_position()

# ---------- HIT ----------

func hit(damage: int) -> void:
	health -= damage
	impact()
	
	if health <= 0:
		kill()

func impact() -> void:
	randomize()
	var x = randi() % 31
	randomize()
	var y = randi() % 31
	var impact = _Impact.instance()
	impact.position = Vector2(x, y)
	impact_pos_node.add_child(impact)

func explode() -> void:
	var explosition = _Explosion.instance()
	explosition.connect("animation_finished", self, "on_explosition_finished")
	add_child(explosition)

func on_explosition_finished() -> void:
	emit_signal("die", reward)
	queue_free()

func kill() -> void:
	get_node("Area2D").queue_free()
	explode()

# ---------- MOVEMENTS ----------

func check_position() -> void:
	if get_unit_offset() == 1:
		emit_signal("base_hit")
		emit_signal("die", 0)
		queue_free()

func move(delta) -> void:
	if health > 0:
		set_offset(get_offset() + speed * delta)
