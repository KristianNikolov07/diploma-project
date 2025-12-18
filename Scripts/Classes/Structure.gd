class_name Structure
extends StaticBody2D

@export var hp : int = 50

func damage_with_axe(damage : int) -> void:
	print("hit")
	hp -= damage
	if hp <= 0:
		queue_free()


func get_save_data() -> Dictionary:
	var data = {
		"hp" = hp
	}
	return data


func load_save_data(data : Dictionary) -> void:
	hp = data.hp
