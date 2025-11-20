extends Area2D

signal hit

@export var damage = 10

func use() -> void:
	print("Test Sword Used")
	$CollisionShape2D.disabled = false
	$Timer.start()
	await $Timer.timeout
	$CollisionShape2D.disabled = true


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(damage)
		hit.emit()
		$CollisionShape2D.disabled = true
