extends CharacterBody2D

var dirx = [-50, 50, 0, 0]
var diry = [-25, 25, 0, 0]
var speed = 250

var raio = null

func _physics_process(_delta):
	flip()
	move_and_slide()

func flip():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	if velocity.x == 0:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play("default")


func _on_timer_timeout():
	randomize()
	var DIRECTIONx = dirx[randi() % dirx.size()]
	var DIRECTIONy = diry[randi() % diry.size()]
	var final_dirx = DIRECTIONx
	var final_diry = DIRECTIONy
	velocity.x = final_dirx
	velocity.y = final_diry


func kill():
	queue_free()


func _on_area_2d_pato_area_entered(area):
	if area.name == "Raio":
		raio = area
		velocity = -position.direction_to(raio.global_position) * speed
		rotation_degrees += 25
		modulate = Color.BLACK
		$Timer_die.start()

	if area.is_in_group("fogo"):
		print("ta na oirra do fogo")


func _on_timer_die_timeout():
	queue_free()
