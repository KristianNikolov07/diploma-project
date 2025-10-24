extends Camera2D

func _ready() -> void:
	limit_left = 0
	limit_top = 0
	limit_right = Properties.tilemap_size * Properties.tile_size
	limit_bottom = Properties.tilemap_size * Properties.tile_size
