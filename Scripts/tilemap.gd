extends TileMapLayer

var grass_tile_atlas_coords = [Vector2i(1, 1)]
var sand_tile_atlas_coords = [Vector2i(4, 1), Vector2i(1, 4)]
var water_tile_atlas_coords = [Vector2i(4, 4)]

func is_water_tile(pos : Vector2i) -> bool:
	if get_cell_atlas_coords(pos) in water_tile_atlas_coords:
		return true
	else:
		return false


func is_sand_tile(pos : Vector2i) -> bool:
	if get_cell_atlas_coords(pos) in sand_tile_atlas_coords:
		return true
	else:
		return false


func is_grass_tile(pos : Vector2i) -> bool:
	if get_cell_atlas_coords(pos) in grass_tile_atlas_coords:
		return true
	else:
		return false


func interact(player : Player):
	if player.inventory.get_selected_item() is WaterContainer:
		var water_container : WaterContainer = player.inventory.get_selected_item()
		water_container.pollute()
		water_container.fill()
