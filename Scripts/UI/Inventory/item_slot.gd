extends Control
@export var item_num = 0

var item
var selected = false

func set_item(_item : Item):
	item = _item
	if _item != null:
		$Item.texture = item.texture
		if item.amount > 1:
			$Amount.text = str(item.amount)
			$Amount.show()
		else:
			$Amount.hide()
		
		if item is Weapon:
			$Durability.max_value = item.max_durability
			if item.durability == item.max_durability:
				$Durability.hide()
			else:
				$Durability.value = item.durability
				$Durability.show()
				print(str(item.durability) + " / " + str(item.max_durability))
		else:
			$Durability.hide() 
	else:
		$Item.texture = null
		$Amount.hide()
		$Durability.hide() 

func select():
	selected = true
	$Selector.show()

func deselect():
	selected = false
	$Selector.hide()
