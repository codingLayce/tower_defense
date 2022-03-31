extends Node

onready var towers_container: = get_node("Towers")

func build_tower(tower: PackedScene, position: Vector2) -> void:
	var new_tower = tower.instance()
	new_tower.position = position
	new_tower.set_name(new_tower.get_name() + "_1")
	
	towers_container.add_child(new_tower, true)
