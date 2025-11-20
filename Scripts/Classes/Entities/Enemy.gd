class_name Enemy
extends Entity

@export var dmg : int

func _ready() -> void:
	if $ContactDamage != null:
		$ContactDamage.body_entered.connect(_contact_damage_on_body_entered)


func _physics_process(_delta) -> void:
	velocity = global_position.direction_to(get_tree().get_first_node_in_group("Player").global_position) * speed
	move_and_slide()


func _contact_damage_on_body_entered(body) -> void:
	if body is Player:
		body.damage(dmg)
