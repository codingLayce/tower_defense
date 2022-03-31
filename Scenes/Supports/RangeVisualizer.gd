extends Node2D

var radius: int = 100

func _draw() -> void:
	draw_circle(position, radius, Color(1, 1, 1, 0.4))
