extends Node2D

var mob_pato = preload("res://Scenes/mobs/pato.tscn")
var mob_humano = preload("res://Scenes/mobs/humao.tscn")
var mob_vaca = preload("res://Scenes/mobs/vaca.tscn")
var mob_porco = preload("res://Scenes/mobs/porco.tscn")
var mob_ovelha = preload("res://Scenes/mobs/ovelha.tscn")

var evt_raio = preload("res://Scenes/events/raio.tscn")
var evt_fogo = preload("res://Scenes/events/fogo.tscn")

var anim_morte = preload("res://Scenes/animations/morte_animation.tscn")


func _ready():
	Global.kill_all.connect(death_animation)
	Global.add_fogo.connect(add_fogo)

	Global.add_ovelha.connect(add_ovelha)
	Global.add_porco.connect(add_porco)
	Global.add_raio.connect(add_raio)
	Global.add_vaca.connect(add_vaca)
	Global.add_humano.connect(add_humano)
	Global.add_pato.connect(add_mob_pato)


func add_mob_pato():
	var PATO = mob_pato.instantiate()
	get_parent().add_child(PATO)
	PATO.position = Vector2(randi_range(1, 500), randi_range(1, 500))


func add_humano():
	var HUMANO = mob_humano.instantiate()
	get_parent().add_child(HUMANO)
	HUMANO.position = Vector2(randi_range(1, 500), randi_range(1, 500))


func add_vaca():
	var VACA = mob_vaca.instantiate()
	get_parent().add_child(VACA)
	VACA.position = Vector2(randi_range(1, 500), randi_range(1, 500))


func add_porco():
	var PORCO = mob_porco.instantiate()
	get_parent().add_child(PORCO)
	PORCO.position = Vector2(randi_range(1, 500), randi_range(1, 500))


func add_raio():
	var RAIO = evt_raio.instantiate()
	get_parent().add_child(RAIO)
	RAIO.position = Vector2(randi_range(1, 500), randi_range(1, 500))


func add_ovelha():
	var OVELHA = mob_ovelha.instantiate()
	get_parent().add_child(OVELHA)
	OVELHA.position = Vector2(randi_range(1, 500), randi_range(1, 500))


func death_animation():
	var ANIM = anim_morte.instantiate()
	get_parent().add_child(ANIM)


func add_fogo():
	var FOGO = evt_fogo.instantiate()
	get_parent().add_child(FOGO)
	FOGO.position = Vector2(randi_range(1, 500), randi_range(1, 500))
