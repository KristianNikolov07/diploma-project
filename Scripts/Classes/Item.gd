class_name Item
extends Resource

@export var item_name = ""
@export var max_amount : int
@export var texture : Texture2D

var amount : int = 1

##Returns the leftover amount
func increase_amount(_amount : int) -> int:
	amount += _amount
	if amount > max_amount:
		var left_over = amount - max_amount
		amount = max_amount
		return left_over
	else:
		return 0


func decrease_amount(_amount : int) -> void:
	amount -= _amount


func get_save_data() -> Dictionary:
	var data = {
		"amount": amount
	}
	return data


func load_save_data(data : Dictionary) -> void:
	amount = data.amount
