extends CharacterBody2D

var raio = null
var rotate = false

func _physics_process(delta):
	if rotate == true:
		rotation_degrees += 10
	move_and_slide()


func kill():
	queue_free()


func _on_area_2d_humano_area_entered(area):
	if area.name == "Raio":
		raio = area
		velocity = - position.direction_to(raio.global_position) * 200
		rotate = true
		modulate = Color.BLACK
		$Timer_die.start()


func _on_timer_die_timeout():
	queue_free()
