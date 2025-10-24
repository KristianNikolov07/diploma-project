extends CharacterBody2D
@export var base_speed = 100
@export var running_gain = 0.5
@export var max_running_speed = 200 

@onready var speed = base_speed
var is_running = false


func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down") * speed
	
	if Input.is_action_pressed("Sprint"):
		if speed + running_gain <= max_running_speed:
			speed += running_gain * delta
	else:
		speed = base_speed
	
	move_and_slide()
