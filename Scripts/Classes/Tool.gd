class_name Tool
extends Item

@export var tool_scene : PackedScene
@export var max_durability = 100
@export var durability = 100

func take_durability(_durability = 1) -> void:
	durability -= _durability
	if durability <= 0:
		durability = 0
