extends Node2D

@onready var mobs: Array[PackedScene] = [
preload("res://Entities/Pig/pig.tscn"),#0
preload("res://Entities/Duck/duck.tscn"),#1
preload("res://Entities/Events/Lightning/lightining.tscn"),#2
preload("res://Entities/Cow/cow.tscn"),#3
preload("res://Entities/Human/human.tscn"),#4
preload("res://Entities/Sheep/sheep.tscn"),#5
preload("res://Entities/Events/Fire/fire.tscn"),#6
]
func _ready() -> void:
	# Conecta os sinais do Global
	Global.add_mob.connect(_on_add_mob)
	Global.kill_all.connect(_on_kill_all)
	
func _on_add_mob(index: int, position: Vector2 = Vector2.ZERO) -> void:
	if index >= 0 or index < mobs.size():
		var new_mob = mobs[index].instantiate()
		get_parent().call_deferred("add_child", new_mob)
		if position == Vector2.ZERO:
			new_mob.global_position = Vector2(randf_range(50, 550), randf_range(50, 550))
		else:
			new_mob.global_position = position
	
func _on_kill_all() -> void:
	get_tree().call_group("mobs", "queue_free")
	print("Todas as entidades foram removidas.")
