extends TileMapLayer

var grass_tile_atlas_coords = Vector2i(0, 0)
var sand_tile_atlas_coords = Vector2i(1, 0)
var water_tile_atlas_coords = Vector2i(2, 0)

func is_water_tile(pos : Vector2i) -> bool:
	if get_cell_atlas_coords(pos) == water_tile_atlas_coords:
		return true
	else:
		return false


func interact(player : Player):
	if player.inventory.get_selected_item() is WaterContainer:
		var water_container : WaterContainer = player.inventory.get_selected_item()
		water_container.pollute()
		water_container.fill()
