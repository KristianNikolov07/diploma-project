class_name PassiveEntity
extends Entity

@export var max_target_distance : float = 100
@export var max_retarget_time : float = 1
@export var min_retarget_time : float = 0.5

func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	_on_retarget_timeout()

func retarget():
	var target : Vector2
	target.x = randf_range(-max_target_distance, max_target_distance)
	target.y = randf_range(-max_target_distance, max_target_distance)
	$NavigationAgent2D.target_position = global_position + target

func _physics_process(delta):
	if $NavigationAgent2D.is_navigation_finished():
		if $Retarget != null:
			if $Retarget.is_stopped() == false:
				return
			$Retarget.start()
		else:
			retarget()

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()


func _on_retarget_timeout() -> void:
	if $Retarget != null:
		$Retarget.wait_time = randf_range(min_retarget_time, max_retarget_time)
	retarget()
