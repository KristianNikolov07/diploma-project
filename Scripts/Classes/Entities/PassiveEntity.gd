class_name PassiveEntity
extends Entity

@export var max_target_distance : float = 100
@export var max_retarget_time : float = 1
@export var min_retarget_time : float = 0.5
@export var min_distance_before_retarget = 1
var target : Vector2

func _ready() -> void:
	retarget()

func retarget():
	target.x = global_position.x + randf_range(-max_target_distance, max_target_distance)
	target.y = global_position.y + randf_range(-max_target_distance, max_target_distance)
	$CollisionCheck.look_at(target)

func _physics_process(_delta):
	if global_position.distance_to(target) <= min_distance_before_retarget or $CollisionCheck.is_colliding():
		if $RetargetTimer.is_stopped():
			#$RetargetTimer.wait_time = randf_range(min_retarget_time, max_retarget_time)
			#$RetargetTimer.start()
			#await $RetargetTimer.timeout
			retarget()
	else:
		velocity = global_position.direction_to(target) * speed
		move_and_slide()
