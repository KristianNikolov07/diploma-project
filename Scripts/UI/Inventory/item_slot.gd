extends Control
@export var item_num = 0

func set_item(item : Item):
	if item != null:
		$Item.texture = item.texture
		if item.amount > 1:
			$Amount.text = str(item.amount)
			$Amount.show()
		else:
			$Amount.hide()
	else:
		$Item.texture = null
		$Amount.hide()
