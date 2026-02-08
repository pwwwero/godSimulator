extends CharacterBody2D


var in_panic: bool = false
var can_bread: bool = false

@export var recharge_sex_timer:float = 10.0
@export var growth_time: float = 15.0

@export var speed: float = 130.0
@export var panic_speed:float = 260.0
@export var friction: float = 0.05 
@export var tremor_intecity: float = 2.0

var current_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("mobs")
	add_to_group("pigs")
	#configuração do timer de crescer
	$Timer.wait_time = growth_time
	$Timer.one_shot=true
	$Timer.start()
	
	if $WalkTimer.is_stopped():
		$WalkTimer.start()

func aging_on_timer_timeout() -> void:
	Global.add_mob.emit(0, global_position)
	queue_free()

func _physics_process(delta: float) -> void:
	$Label.text = str(velocity)
	if in_panic:
		$Baby_Pig_AnimatedSprite2D.offset = Vector2(#EFEITO DE TREMER ENQUAANTO PEGA FOGO
			randf_range(-tremor_intecity, tremor_intecity),
			randf_range(-tremor_intecity, tremor_intecity))
	else:
		velocity = current_velocity
	
	_handle_animation()
	move_and_slide()

func _handle_walk():
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if randf() < 0.1:
		velocity = Vector2.ZERO
	else:
		if in_panic:
			current_velocity = random_direction * panic_speed
			$WalkTimer.wait_time = 0.3
		else:
			current_velocity = current_velocity * speed
			$WalkTimer.wait_time = 0.3
	$WalkTimer.start()

func _on_walk_timer_timeout() -> void:
	_handle_walk()

func _handle_animation() -> void:
	if velocity.length() > 0.1:
		$Baby_Pig_AnimatedSprite2D.play("adult")
		$Baby_Pig_AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$Baby_Pig_AnimatedSprite2D.stop()

func _on_baby_pig_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fire"):
		_start_fire()
	elif area.get_parent().is_in_group("pigs"):
		if area.get_parent().in_panic:
			_start_fire()

	if area.name == "Raio" or area.is_in_group("lightning"):
		#(Knockback)
		var push_dir = (global_position - area.global_position).normalized()
		velocity = push_dir * 700
		_knlockback_effect()
		_burn_die()

##################################################################################
##################################################################################
func _knlockback_effect():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2.5, 2.5), 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _start_fire():
	if in_panic: return
	$CPUParticles2D.emitting = true
	modulate = Color.RED
	_burn_die()

func _burn_die():
	if in_panic: return
	in_panic = true
	_on_walk_timer_timeout()
	get_tree().create_timer(randf_range(4.0, 8.0)).timeout.connect(queue_free)
###################################################################################
