extends Node

@export var hunger : float = 0
@export var max_hunger : float = 100
@export var hunger_add_time : float = 30
@export var hunger_damage = 5
@export var hunger_damage_time = 3

@onready var player : Player = get_parent()
@onready var hunger_bar : ProgressBar = get_node("../UI/Stats/Hunger")

func _ready() -> void:
	$HungerTimer.wait_time = hunger_add_time
	$HungerTimer.start()
	
	$HungerHPTick.wait_time = hunger_damage_time
	$HungerHPTick.start()
	
	hunger_bar.max_value = max_hunger


func add_hunger(_hunger : float = 1):
	hunger += _hunger
	if hunger > max_hunger:
		hunger = max_hunger
	hunger_bar.value = hunger


func remove_hunger(_hunger : float):
	hunger -= _hunger
	if hunger < 0:
		hunger = 0
	hunger_bar.value = hunger


func set_hunger(_hunger : float):
	hunger = _hunger
	hunger_bar.value = hunger


func set_natural_hunger_timer(time : float):
	hunger_add_time = time
	if $HungerTimer.time_left > time:
		_on_hunger_timer_timeout()


func _on_hunger_timer_timeout() -> void:
	if hunger_add_time != $HungerTimer.wait_time:
		$HungerTimer.stop()
		$HungerTimer.wait_time = hunger_add_time
		$HungerTimer.start()
	
	add_hunger()


func _on_hunger_hp_tick_timeout() -> void:
	if hunger == max_hunger:
		player.damage(hunger_damage)
