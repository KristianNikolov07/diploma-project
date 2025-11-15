class_name Entity
extends CharacterBody2D

@export var max_hp = 100
@export var speed = 50
var hp : int

func _ready() -> void:
	hp = max_hp

func damage(damage : int):
	hp -= damage
	if hp <= 0:
		queue_free()
