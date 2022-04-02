extends Popup

onready var name_lbl: Label = get_node("MarginContainer/VBoxContainer/LblTowerName")
onready var cost_lbl: Label = get_node("MarginContainer/VBoxContainer/CostContainer/LblCost")
onready var damage_lbl: Label = get_node("MarginContainer/VBoxContainer/DamageContainer/LblDamage")
onready var rof_lbl: Label = get_node("MarginContainer/VBoxContainer/RofContainer/LblRof")

func on_create(name: String, cost: int, damage: int, rof: float) -> void:
	name_lbl.text = name
	cost_lbl.text = str(cost)
	damage_lbl.text = str(damage)
	rof_lbl.text = str(rof)
