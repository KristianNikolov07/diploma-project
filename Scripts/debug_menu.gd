extends CanvasLayer

signal list_inventory_pressed
signal add_test_item_pressed
signal remove_test_item_pressed
signal add_test_consumable_pressed
signal add_basic_sword
signal damage_player_pressed
signal heal_player_pressed

var test_entity_scene = preload("res://Scenes/Entity/test_entity.tscn")
var test_enemy_scene = preload("res://Scenes/Entity/Enemies/test_enemy.tscn")

func _ready() -> void:
	$Debug.hide()


func _input(event: InputEvent) -> void:
	if "debug" in OS.get_cmdline_args():
		if event.is_action_pressed("Debug"):
			$Debug.visible = !$Debug.visible


func _on_list_inventory_pressed() -> void:
	list_inventory_pressed.emit()


func _on_add_test_item_pressed() -> void:
	add_test_item_pressed.emit()


func _on_remove_test_item_pressed() -> void:
	remove_test_item_pressed.emit()


func _on_add_test_consumable_pressed() -> void:
	add_test_consumable_pressed.emit()


func _on_add_basic_sword_pressed() -> void:
	add_basic_sword.emit()


func _on_damage_player_pressed() -> void:
	damage_player_pressed.emit()


func _on_heal_player_pressed() -> void:
	heal_player_pressed.emit()


func _on_save_pressed() -> void:
	SaveProgress.save_name = "Test"
	SaveProgress.save()


func _on_load_pressed() -> void:
	SaveProgress.save_name = "Test"
	SaveProgress.load()


func _on_spawn_test_entity_pressed() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	var entity : Entity = test_entity_scene.instantiate()
	entity.global_position = player.global_position
	player.get_parent().add_child(entity)


func _on_spawn_test_enemy_pressed() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	var enemy : Enemy = test_enemy_scene.instantiate()
	enemy.global_position = player.global_position
	player.get_parent().add_child(enemy)
