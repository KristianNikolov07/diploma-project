class_name Weapon
extends Item

@export var has_durability = true
@export var durability = 100
@export var weapon_scene : PackedScene

var broken = false
# TODO: Think about the weapon's implementation

func use(player : CharacterBody2D):
	if !broken:
		var node = weapon_scene.instantiate()
		node.global_position = player.global_position
		player.add_child(node)
		
		if durability <= 0:
			broken = true
