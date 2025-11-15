extends Node
@onready var tilemap : TileMapLayer = get_node("../Tilemap")
@onready var spawn_points_node : Node = get_node("../SpawnPoints")
@onready var player : Player = get_node("../Player")
var tree_scene = preload("res://Scenes/Objects/tree.tscn")


var grass_tile_atlas_coords = Vector2i(0, 0)
var sand_tile_atlas_coords = Vector2i(1, 0)
var water_tile_atlas_coords = Vector2i(2, 0)

@export_range(0, 100, 1) var tree_spawn_change = 10

func _ready() -> void:
	generate_trees()
	choose_spawn_point()
	
func generate_trees():
	for x in range(Global.tilemap_size):
		for y in range(Global.tilemap_size):
			if tilemap.get_cell_atlas_coords(Vector2i(x, y)) == grass_tile_atlas_coords:
				var random = randi_range(0, 100)
				if random <= tree_spawn_change:
					var tree = tree_scene.instantiate()
					tree.global_position = Global.tilemap_coords_to_global_coords(Vector2(x, y))
					get_parent().add_child.call_deferred(tree)
					

func choose_spawn_point():
	var rand = randi_range(0, spawn_points_node.get_child_count())
	var i = 0
	for child in spawn_points_node.get_children():
		if i == rand:
			player.global_position = child.global_position
		else:
			child.queue_free()
		i += 1
