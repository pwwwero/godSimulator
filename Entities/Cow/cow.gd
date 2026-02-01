extends CharacterBody2D

var dirx = [-30,30, 0, 0, 0, 0, 0]
var diry = [-10,10, 0, 0, 0, 0, 0]

var raio = null
var rotate = false

func _physics_process(delta):
	if rotate == true:
		rotation_degrees += 25
	flip()
	move_and_slide()

func flip():
	if velocity.x <0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	if velocity.x == 0:
		$AnimatedSprite2D.stop()
	else: 
		$AnimatedSprite2D.play("default")

func _on_timer_timeout():
	randomize()
	var DIRECTIONx = dirx[randi()% dirx.size()]
	var DIRECTIONy = diry[randi()% diry.size()]
	var final_dirx = DIRECTIONx
	var final_diry = DIRECTIONy
	velocity.x = final_dirx
	velocity.y = final_diry

func kill():
	queue_free()


func _on_area_2d_vaca_area_entered(area):
	if area.name == "Raio":
		raio = area
		velocity = - position.direction_to(raio.global_position) * 200
		rotate = true
		modulate = Color.BLACK
		$Timer_die.start()


func _on_timer_die_timeout():
	queue_free()
