extends Node

@export var passiveEntityes : Array[PackedScene]
@export var enemies : Array[PackedScene]
@export var min_distance_from_player : float
@export var max_distance_from_player : float
@export var spawn_amount = 5

@onready var day_night_cycle: DirectionalLight2D = $"../DayNightCycle"
@onready var player: Player = %Player


func _on_spawn_attempt_timeout() -> void:
	var entity_scene : PackedScene
	if day_night_cycle.is_night:
		entity_scene = enemies.pick_random()
	else:
		entity_scene = passiveEntityes.pick_random()
	
	for i in range(spawn_amount):
		var entity = entity_scene.instantiate()
		var distance : Vector2
		distance.x = randf_range(min_distance_from_player, max_distance_from_player)
		distance.y = randf_range(min_distance_from_player, max_distance_from_player)
		if randi_range(0, 1) == 0:
			distance.x = -distance.x
		if randi_range(0, 1) == 0:
			distance.y = -distance.y
		entity.global_position = player.global_position + distance
		
		get_parent().add_child(entity)
