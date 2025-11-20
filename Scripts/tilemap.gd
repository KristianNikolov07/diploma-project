extends TileMapLayer

var add_navigation_to_tiles : Array[Vector2i]
var remove_navigation_from_tiles : Array[Vector2i]

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if coords in remove_navigation_from_tiles or coords in add_navigation_to_tiles:
		return true
	return false


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in remove_navigation_from_tiles:
		tile_data.set_navigation_polygon(0, null)
		remove_navigation_from_tiles.erase(coords)
	elif coords in add_navigation_to_tiles:
		tile_data.set_navigation_polygon(0, NavigationPolygon.new())
		add_navigation_to_tiles.erase(coords)
