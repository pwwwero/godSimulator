extends Node2D

signal entity_requested

@onready var duck_button = $Buttons/Duck

func _ready():
		duck_button.button_down.connect(emit_enemy_requested)

func emit_enemy_requested() -> void:
	entity_requested.emit()
