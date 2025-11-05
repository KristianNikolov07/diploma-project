class_name Tool
extends Item

@export var tool_scene : PackedScene
@export var has_durability = true
@export var max_durability = 100
@export var durability = 100

var broken = false

func take_durability(_durability = 1):
	durability -= _durability
	if durability <= 0:
		broken = true
