extends CharacterBody2D


# > | Variables | <
var in_panic: bool = false
var can_bread: bool = false

@export var recharge_sex_timer:float = 10.0
@export var growth_time: float = 15.0

@export var speed: float = 130.0
@export var panic_speed:float = 260.0
@export var friction: float = 0.05 
@export var tremor_intecity: float = 2.0
var random_direction: Vector2

# > | Nodes | <
@onready var walk_timer: Timer = $WalkTimer
@onready var timer: Timer = $Timer

func _ready() -> void:
	add_to_group("mobs")
	add_to_group("pigs")
	#configuração do timer de crescer
	timer.wait_time = growth_time
	
	walk_timer.timeout.connect(_handle_walk)
	timer.timeout.connect(_aging_timeout)

func _aging_timeout() -> void:
	Global.add_mob.emit(0, global_position)
	queue_free()

func _physics_process(delta: float) -> void:
	if in_panic:
		$Baby_Pig_AnimatedSprite2D.offset = Vector2(#EFEITO DE TREMER ENQUAANTO PEGA FOGO
			randf_range(-tremor_intecity, tremor_intecity),
			randf_range(-tremor_intecity, tremor_intecity))
			
	velocity = random_direction * speed
	_handle_animation()
	move_and_slide()

func _handle_walk():
	random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if randf() < 0.2:
		speed = 0
	else:
		speed = 30.0
		
	if in_panic:
		velocity = random_direction * panic_speed
		walk_timer.wait_time = 0.3

func _handle_animation() -> void:
	if velocity.length() > 0.1:
		$Baby_Pig_AnimatedSprite2D.flip_h = velocity.x < 0
		$Baby_Pig_AnimatedSprite2D.play()
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

func _knlockback_effect():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2.5, 2.5), 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _start_fire():
	if in_panic: return
	modulate = Color.RED
	_burn_die()

func _burn_die():
	if in_panic: return
	in_panic = true
	_handle_walk()
	get_tree().create_timer(randf_range(4.0, 8.0)).timeout.connect(queue_free)
