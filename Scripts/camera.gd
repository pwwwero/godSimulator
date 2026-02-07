extends Camera2D

var shake_duration := 0.9
var shake_amplitude := 9.0
var shake_timer := 0.0
var original_position = Vector2.ZERO

func _ready() -> void:
	Global.add_mob.connect(shake)
	Global.kill_all.connect(shake)

func shake():
	shake_timer = shake_duration

func _process(delta):
	if shake_timer > 0.0:
		shake_timer -= delta

	if shake_timer <= 0.0:
		position = original_position
	else:
		position = (
			original_position
			+ Vector2(
				randf_range(-shake_amplitude, shake_amplitude),
				randf_range(-shake_amplitude, shake_amplitude)
			)
		)
