extends Control

enum Type{
	ITEM,
	ARMOR,
	BACKPACK
}

@export var type : Type = Type.ITEM

var item
var selected = false


func set_item(_item : Item) -> void:
	item = _item
	if _item != null:
		$Item.texture = item.texture
		if item.amount > 1:
			$Amount.text = str(item.amount)
			$Amount.show()
		else:
			$Amount.hide()
		
		if item is Tool or item is Armor:
			$Durability.max_value = item.max_durability
			if item.durability == item.max_durability:
				$Durability.hide()
			else:
				$Durability.value = item.durability
				$Durability.show()
		else:
			$Durability.hide() 
	else:
		$Item.texture = null
		$Amount.hide()
		$Durability.hide() 


func select() -> void:
	selected = true
	$Selector.show()


func deselect() -> void:
	selected = false
	$Selector.hide()


func _on_button_pressed() -> void:
	if type == Type.ARMOR:
		get_parent().unequip_armor()
