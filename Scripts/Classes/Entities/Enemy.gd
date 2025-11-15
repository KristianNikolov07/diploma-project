class_name Enemy
extends Entity

@export var dmg : int

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	if $ContactDamage != null:
		$ContactDamage.body_entered.connect(_contact_damage_on_body_entered)
	

func retarget():
	$NavigationAgent2D.target_position = get_tree().get_first_node_in_group("Player").global_position

func _physics_process(delta):
	retarget()
	if $NavigationAgent2D.is_navigation_finished():
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()

func _contact_damage_on_body_entered(body):
	if body is Player:
		body.damage(dmg)
