extends Area2D

@onready var spawn_chance: float = 0.5
@onready var spread_radius: float = 25.0
@onready var fire_amout: int = 2
@onready var max_time:float = 7.0
@onready var min_time:float = 1.0


func _ready() -> void:
	add_to_group("fire")
	add_to_group("mobs")
	var time_life = randf_range(min_time, max_time)
	_shrink_die(time_life)


func _shrink_die(life_time: float):
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, life_time)
	
func _on_timer_morrer_timeout():
	for i in range(fire_amout):
		if randf() < spawn_chance:
			var circle_range = Vector2(randf_range(-spread_radius, spread_radius),randf_range(-spread_radius, spread_radius))
			var new_pos = global_position + circle_range
			Global.add_mob.emit(6, new_pos)
	queue_free()
