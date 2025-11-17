class_name StructureItem
extends Item

@export var structure_scene : PackedScene
@export var preview_texture : Texture

func place(player : Player, placement_location : Vector2):
	print("Placing structure")
	var location = Global.global_coords_to_tilemap_coords(placement_location)
	print(location)
	location = Global.tilemap_coords_to_global_coords(location)
	var structure_node = structure_scene.instantiate()
	structure_node.global_position = location
	player.get_parent().add_child(structure_node)
	
