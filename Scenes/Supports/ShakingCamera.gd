extends Camera2D

onready var shake_timer: Timer = $Timer
onready var tween: Tween = $Tween

var default_offset: = offset
var shake_amount: = 0

func _ready() -> void:
	set_process(false)

func _process(delta) -> void:
	offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(shake_amount, -shake_amount)) * delta + default_offset

func shake(new_shake, shake_time=0.4, shake_limit=100) -> void:
	shake_amount += new_shake
	if shake_amount > shake_limit:
		shake_amount = shake_limit
	
	shake_timer.wait_time = shake_time
	
	tween.stop_all()
	set_process(true)
	shake_timer.start()


func _on_Timer_timeout():
	shake_amount = 0
	set_process(false)
	
	tween.interpolate_property(self, "offset", offset, default_offset, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()