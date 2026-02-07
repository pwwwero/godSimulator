extends CharacterBody2D

var rotate_death: bool = false
var in_panic: bool = false

@export var can_bread = true
@export var recharge_sex_timer:float = 8.0

@export var speed: float = 90.0
@export var panic_speed:float = 210.0
@export var friction: float = 0.05 
@export var tremor_intecity: float = 2.0

func _ready() -> void:
	print("porco nasceu!!")
	
	add_to_group("pigs")
	add_to_group("mobs")

func _physics_process(delta: float) -> void:
	if in_panic:
		$AnimatedSprite2D.offset = Vector2(#EFEITO DE TREMER ENQUAANTO PEGA FOGO
			randf_range(-tremor_intecity, tremor_intecity),
			randf_range(-tremor_intecity, tremor_intecity))
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	_handle_animation()
	move_and_slide()

func _handle_animation() -> void:
	if velocity.length() > 0.1:
		$AnimatedSprite2D.play("default")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.stop()

func _on_timer_timeout() -> void:
	_handle_walk()

func _handle_walk():
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if randf() < 0.2:
		velocity = Vector2.ZERO
	else:
		velocity = random_direction * speed
	if in_panic:
		velocity = random_direction * panic_speed
		$Timer.wait_time = 0.3
	if not in_panic:
		velocity = velocity.lerp(Vector2.ZERO, friction)

func _on_area_2d_porco_area_entered(area: Area2D) -> void:
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

	var another_body = area.get_parent()
	if another_body.is_in_group("pigs") and not in_panic and not another_body.in_panic:
		#print("encontrou pig")
		if can_bread and another_body.can_bread:
			_bread(another_body)
	
######################################################################################
func _bread(partner):
	can_bread = false
	partner.can_bread = false
	modulate = Color.BLUE
	
	var puppy_pos = global_position
	Global.add_mob.emit(0, puppy_pos)
	get_tree().create_timer(recharge_sex_timer).timeout.connect(_reset_bread)
	
func _reset_bread():
	can_bread = true
	modulate = Color.WHITE
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
	in_panic=true
	_on_timer_timeout()
	get_tree().create_timer(randf_range(4.0, 8.0)).timeout.connect(queue_free)
###################################################################################
