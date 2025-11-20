class_name Consumable
extends Item

@export var has_unlimited_uses = false
##0 if infinite
#@export var effect_duration = 0
#TODO : Make a system for temporary effects
@export var speed_modifier : int
@export var running_speed_gain_modifier : int
@export var max_running_speed_modifier : int
#TODO: Add more modifiers

var player : Player

func use(_player : Player) -> void:
	player = _player
	player.base_speed += speed_modifier
	player.running_speed_gain += running_speed_gain_modifier
	player.max_running_speed += max_running_speed_modifier
