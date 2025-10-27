extends Area2D
@export var item : Item

func _ready() -> void:
	$ItemTexture.texture = item.texture

func interact(player : CharacterBody2D):
	if player.add_item(item):
		queue_free()
