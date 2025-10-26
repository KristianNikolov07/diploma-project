extends Control
@export var item_num = 0
var item

func set_item(_item : Item):
	item = _item
	if _item != null:
		$Item.texture = item.texture
		if item.amount > 1:
			$Amount.text = str(item.amount)
			$Amount.show()
		else:
			$Amount.hide()
	else:
		$Item.texture = null
		$Amount.hide()
