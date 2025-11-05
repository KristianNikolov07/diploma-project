extends Node2D
@export var damage = 10
var hit = false

func use():
	look_at(get_global_mouse_position())
	$Area2D/CollisionShape2D.disabled = false
	if get_global_mouse_position().x < global_position.x:
		$Area2D/AnimationPlayer.play_backwards("hit")
	else:
		$Area2D/AnimationPlayer.play("hit")
	await $Area2D/AnimationPlayer.animation_finished
	$Area2D/CollisionShape2D.disabled = true
	if hit:
		hit = false
		return true
	else:
		return false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("damage_with_axe"):
		body.damage_with_axe(damage)
		hit = true
