extends Control

@export var item : Item
@export var amount : int

func set_item(_item : Item, _amount : int = 1, avaliable = true) -> void:
	item = _item
	if item != null:
		$ItemTexture.texture = item.texture
		
		amount = _amount
		if amount > 1:
			$Amount.text = str(amount)
			$Amount.show()
		else:
			$Amount.hide()
		
		if avaliable:
			$ItemTexture.self_modulate = Color(1, 1, 1, 1)
			$Amount.self_modulate = Color(1, 1, 1, 1)
		else:
			$ItemTexture.self_modulate = Color(1, 1, 1, 0.5)
			$Amount.self_modulate = Color(1, 1, 1, 0.5)
	else:
		$ItemTexture.texture = null
		$Amount.hide()
