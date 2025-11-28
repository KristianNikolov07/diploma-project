extends Node

@export_group("Hunger")
@export var hunger : float = 0
@export var max_hunger : float = 10
@export var hunger_add_time : float = 30
@export var hunger_damage = 5
@export var hunger_damage_time = 3

@export_group("Thirst")
@export var thirst : float = 0
@export var max_thirst : float = 10
@export var thirst_add_time : float = 30
@export var thirst_damage = 5
@export var thirst_damage_time = 3

@onready var player : Player = get_parent()
@onready var hunger_bar : ProgressBar = get_node("../UI/Stats/Hunger")
@onready var thirst_bar : ProgressBar = get_node("../UI/Stats/Thirst")

func _ready() -> void:
	$HungerTimer.wait_time = hunger_add_time
	$HungerTimer.start()
	
	$HungerHPTick.wait_time = hunger_damage_time
	$HungerHPTick.start()
	
	$ThirstTimer.wait_time = thirst_add_time
	$ThirstTimer.start()
	
	$ThirstHPTick.wait_time = thirst_damage_time
	$ThirstHPTick.start()
	
	hunger_bar.max_value = max_hunger
	thirst_bar.max_value = max_thirst


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


func add_thirst(_thirst : float = 1):
	thirst += _thirst
	if thirst > max_thirst:
		thirst = max_thirst
	thirst_bar.value = thirst


func remove_thirst(_thirst : float):
	thirst -= _thirst
	if thirst < 0:
		thirst = 0
	thirst_bar.value = thirst


func set_thirst(_thirst : float):
	thirst = _thirst
	thirst_bar.value = thirst


func set_natural_thirst_timer(time : float):
	thirst_add_time = time
	if $ThirstTimer.time_left > time:
		_on_thirst_timer_timeout()


func can_sprint() -> bool:
	if hunger < max_hunger and thirst < max_thirst:
		return true
	else:
		return false


func _on_hunger_timer_timeout() -> void:
	if hunger_add_time != $HungerTimer.wait_time:
		$HungerTimer.stop()
		$HungerTimer.wait_time = hunger_add_time
		$HungerTimer.start()
	
	add_hunger()


func _on_hunger_hp_tick_timeout() -> void:
	if hunger == max_hunger:
		player.damage(hunger_damage)


func _on_thirst_timer_timeout() -> void:
	if thirst_add_time != $ThirstTimer.wait_time:
		$ThirstTimer.stop()
		$ThirstTimer.wait_time = thirst_add_time
		$ThirstTimer.start()
	
	add_thirst()


func _on_thirst_hp_tick_timeout() -> void:
	if thirst == max_thirst:
		player.damage(thirst_damage)
