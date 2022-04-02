extends "res://Scenes/Tanks/Tank.gd"

func _ready() -> void:
	health = GameData.tanks_data["TankT1"].health
	speed = GameData.tanks_data["TankT1"].speed
