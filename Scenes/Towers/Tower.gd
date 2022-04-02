extends Node2D

enum TowerTargetStrategy {TARGETING_FIRST}

onready var turret_node: Sprite = get_node("Turret")
onready var collision_node: CollisionShape2D = get_node("CollisionShape2D")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

export var tower_type: String = "GunT1"
export var tower_rof: float = 0
export var tower_damage: int = 0
export var tower_cost: int = 0

var activated: bool = false

var tower_targeting_strategy = TowerTargetStrategy.TARGETING_FIRST 
var enemies_in_range: Array = []
var current_target
var ready_to_fire: bool = true

# -------------------- CALLBACKS --------------------

func _init() -> void:
	var tower_data = GameData.towers_data[tower_type]
	tower_rof = tower_data.rof
	tower_damage = tower_data.damage
	tower_cost = tower_data.cost

func _ready() -> void:
	collision_node.shape.radius = GameData.towers_data[tower_type].range

func _physics_process(delta) -> void:
	if enemies_in_range.size() != 0:
		choose_target()
		turret_node.look_at(current_target.position + Vector2(current_target.h_offset, current_target.v_offset))
		if ready_to_fire:
			fire()

# -------------------- SIGNALS --------------------

func _on_GunT1_body_entered(body):
	if not activated:
		return
	enemies_in_range.append(body.get_parent())

func _on_GunT1_body_exited(body):
	if not activated:
		return
	enemies_in_range.erase(body.get_parent())

# -------------------- TARGET --------------------

func fire() -> void:
	ready_to_fire = false
	current_target.hit(tower_damage)
	anim_player.play("Fire")
	yield(get_tree().create_timer(tower_rof), "timeout")
	ready_to_fire = true

func choose_target() -> void:
	match tower_targeting_strategy:
		TowerTargetStrategy.TARGETING_FIRST:
			_targeting_first()

func _targeting_first() -> void:
	var max_offset = 0
	current_target = null
	
	for enemy in enemies_in_range:
		var offset = enemy.get_unit_offset()
		if offset > max_offset:
			max_offset = offset
			current_target = enemy
