class_name Item
extends Resource

@export var item_name = ""
@export var max_amount : int
@export var texture : Texture2D

var amount = 1

##Returns the leftover amount
func increase_amount(_amount : int):
	
	amount += _amount
	if amount > max_amount:
		var left_over = amount - max_amount
		amount = max_amount
		return left_over
	else:
		return 0

func decrease_amount(_amount : int):
	amount -= _amount
		
