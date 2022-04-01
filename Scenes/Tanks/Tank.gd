extends PathFollow2D

signal base_hit()
signal die()

export var speed: int = 150
export var health: int = 100

# ---------- CALLBACKS ----------

func _physics_process(delta: float) -> void:
	move(delta)
	check_position()

# ---------- HIT ----------

func hit(damage: int) -> void:
	health -= damage
	
	if health <= 0:
		die()

func die() -> void:
	emit_signal("die")
	queue_free()

# ---------- MOVEMENTS ----------

func check_position() -> void:
	if get_unit_offset() == 1:
		emit_signal("base_hit")
		die()

func move(delta) -> void:
	set_offset(get_offset() + speed * delta)
