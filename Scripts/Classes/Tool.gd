class_name Tool
extends Item

@export var tool_scene : PackedScene
@export var max_durability = 100
@export var durability = 100

func take_durability(_durability = 1) -> void:
	durability -= _durability
	if durability <= 0:
		durability = 0


func get_save_data() -> Dictionary:
	var data = {
		"name" : item_name,
		"texture": texture.resource_path,
		"amount": amount,
		"max_amount": max_amount,
		"tool_scene": tool_scene.resource_path,
		"max_durability": max_durability,
		"durability": durability
	}
	return data


func load_save_data(data : Dictionary) -> void:
	item_name = data.name
	texture = load(data.texture)
	amount = data.amount
	max_amount = data.max_amount
	tool_scene = load(data.tool_scene)
	max_durability = data.max_durability
	durability = data.durability
