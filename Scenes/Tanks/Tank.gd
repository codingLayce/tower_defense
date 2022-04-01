extends PathFollow2D

signal base_hit()
signal die()

export var speed: int = 150

# ---------- CALLBACKS ----------

func _physics_process(delta: float) -> void:
	move(delta)
	check_position()

# ---------- CUSTOMS ----------

func check_position() -> void:
	if get_unit_offset() == 1:
		emit_signal("base_hit")
		emit_signal("die")
		queue_free()

func move(delta) -> void:
	set_offset(get_offset() + speed * delta)
