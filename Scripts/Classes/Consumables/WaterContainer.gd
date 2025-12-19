@tool
class_name WaterContainer
extends Consumable

@export var capacity : int = 1
@export var thirst_modifier_when_clean : float
@export var thirst_modifier_when_polluted : float
@export var water_amount : int = 0
@export var is_clean = false

func _init() -> void:
	has_unlimited_uses = true


func fill():
	water_amount = capacity


func clean():
	is_clean = true
	thirst_modifier = thirst_modifier_when_clean


func pollute():
	is_clean = false
	thirst_modifier = thirst_modifier_when_polluted


func use(player : Player) -> void:
	if water_amount > 0:
		super.use(player)
		water_amount -= 1
	
