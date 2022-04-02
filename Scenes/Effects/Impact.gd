extends AnimatedSprite

func _ready() -> void:
	play()

func _on_Impact_animation_finished():
	queue_free()
