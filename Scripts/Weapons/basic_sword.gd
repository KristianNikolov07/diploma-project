extends Area2D
@export var damage = 10
var hit = false

func use():
	print("Test Sword Used")
	$CollisionShape2D.disabled = false
	$Timer.start()
	await $Timer.timeout
	$CollisionShape2D.disabled = true
	if hit:
		hit = false
		return true
	else:
		return false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(damage)
		hit = true
