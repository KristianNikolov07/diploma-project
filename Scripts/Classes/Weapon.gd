class_name Weapon
extends Item

@export var has_durability = true
@export var max_durability = 100
@export var durability = 100
@export var weapon_scene : PackedScene

var broken = false

func take_durability(_durability = 1):
	durability -= _durability
	if durability <= 0:
		broken = true
