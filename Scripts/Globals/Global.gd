extends Node

var tile_size = 16
var tilemap_scale = 4
var tilemap_size = 256

func tilemap_coords_to_global_coords(tilemap_coords : Vector2) -> Vector2:
	var x = tilemap_coords.x * tile_size * tilemap_scale + tile_size / 2
	var y = tilemap_coords.y * tile_size * tilemap_scale + tile_size / 2
	return Vector2(x, y)


func global_coords_to_tilemap_coords(global_coords : Vector2) -> Vector2:
	var x : int = global_coords.x / (tile_size * tilemap_scale)
	var y : int = global_coords.y / (tile_size * tilemap_scale)
	return Vector2(x, y)
