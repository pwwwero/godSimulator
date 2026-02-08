extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_pig_pressed() -> void:
	Global.add_mob.emit(0)#pig
func _on_duck_pressed() -> void:
	Global.add_mob.emit(1)#duck
func _on_cow_pressed() -> void:
	Global.add_mob.emit(3)#cow
func _on_lightning_pressed() -> void:
	Global.add_mob.emit(2)#lighting
func _on_human_pressed() -> void:
	Global.add_mob.emit(4)#human
func _on_sheep_pressed() -> void:
	Global.add_mob.emit(5)
func _on_fire_pressed() -> void:
	Global.add_mob.emit(6)
	
###########INDEX (7) -- BABY PIG##################3
func _on_kill_all_pressed() -> void:
	
	Global.add_mob.emit(8)
