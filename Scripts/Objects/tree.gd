extends StaticBody2D

var hp = 50

func damage_with_axe(damage : int) -> void:
	print("hit")
	hp -= damage
	if hp <= 0:
		queue_free()
