class_name StructureItem
extends Item

@export var structure_scene : PackedScene
@export var preview_texture : Texture

func place(player : Player, placement_location : Vector2) -> void:
	var structure_node = structure_scene.instantiate()
	structure_node.global_position = placement_location
	player.get_parent().add_child(structure_node)


func get_save_data() -> Dictionary:
	var data = {
		"name" : item_name,
		"texture": texture.resource_path,
		"amount": amount,
		"max_amount": max_amount,
		"structure_scene": structure_scene.resource_path,
		"preview_texture": preview_texture.resource_path
	}
	return data


func load_save_data(data : Dictionary) -> void:
	item_name = data.name
	texture = load(data.texture)
	amount = data.amount
	max_amount = data.max_amount
	structure_scene = load(data.structure_scene)
	preview_texture = load(data.preview_texture)
