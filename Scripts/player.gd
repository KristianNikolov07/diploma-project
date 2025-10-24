extends CharacterBody2D
@export var base_speed = 100
@export var running_speed_gain = 5
@export var max_running_speed = 200 
@export var max_stamina = 200
@export var stamina_decrease_rate = 1
@export var stamina_recharge_rate = 0.25
@export var sprint_stamina_requirement_percent = 50

@onready var speed = base_speed
@onready var stamina = max_stamina
var is_running = false

func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down") * speed
	
	#Running
	if Input.is_action_pressed("Sprint") and stamina > 0:
		is_running = true
		speed += speed / running_speed_gain
		if speed > max_running_speed:
			speed = max_running_speed
	else:
		is_running = false
		speed = base_speed
	
	move_and_slide()
	
	#Stamina
	if is_running:
		stamina -= stamina_decrease_rate
	elif velocity != Vector2.ZERO:
		stamina += stamina_recharge_rate
		if stamina > max_stamina:
			stamina = max_stamina
	else:
		stamina += stamina_recharge_rate * 2
		if stamina > max_stamina:
			stamina = max_stamina
	$Stamina.value = stamina / max_stamina * 100
