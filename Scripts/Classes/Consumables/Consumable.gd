class_name Consumable
extends Item

@export var has_unlimited_uses = false

#TODO : Make a system for temporary effects

@export var speed_modifier : int
@export var running_speed_gain_modifier : int
@export var max_running_speed_modifier : int
@export var hunger : float
@export var thirst : float

var player : Player

func use(_player : Player) -> void:
	player = _player
	player.base_speed += speed_modifier
	player.running_speed_gain += running_speed_gain_modifier
	player.max_running_speed += max_running_speed_modifier
	player.hunger_and_thirst.remove_hunger(hunger)
	player.hunger_and_thirst.remove_thirst(thirst)


func get_save_data() -> Dictionary:
	var data = {
		"name" : item_name,
		"texture": texture.resource_path,
		"amount": amount,
		"max_amount": max_amount,
		"has_unlimited_uses": has_unlimited_uses,
		"speed_modifier": speed_modifier,
		"running_speed_gain_modifier": running_speed_gain_modifier,
		"max_running_speed_modifier": max_running_speed_modifier,
		"hunger": hunger,
		"thirst": thirst
	}
	return data


func load_save_data(data : Dictionary) -> void:
	item_name = data.name
	texture = load(data.texture)
	amount = data.amount
	max_amount = data.max_amount
	has_unlimited_uses = data.has_unlimited_uses
	speed_modifier = data.speed_modifier
	running_speed_gain_modifier = data.running_speed_gain_modifier
	max_running_speed_modifier = data.max_running_speed_modifier
	hunger = data.hunger
	thirst = data.thirst
