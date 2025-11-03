extends Control

@export var item : Item

func set_item(_item : Item, avaliable = true):
	item = _item
	if item != null:
		$ItemTexture.texture = item.texture
		if avaliable:
			$ItemTexture.self_modulate = Color(1, 1, 1, 1)
		else:
			$ItemTexture.self_modulate = Color(1, 1, 1, 0.5)
	else:
		$ItemTexture.texture = null
