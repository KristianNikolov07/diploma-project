extends Area2D

@export var item : Item
@export var can_despawn = true

func _ready() -> void:
	$ItemTexture.texture = item.texture
	if can_despawn:
		$DespawnTimer.start()


func interact(player : CharacterBody2D) -> void:
	if player.inventory.add_item(item):
		queue_free()


func get_save_data() -> Dictionary:
	var folder_path = "res://Resources/Items"
	if item is Armor:
		folder_path += "/Armor"
	elif item is Backpack:
		folder_path += "/Backpack"
	elif item is Consumable:
		folder_path += "/Consumables"
	elif item is StructureItem:
		folder_path += "/Structures"
	elif item is Tool:
		folder_path += "/Tools"

	var data = {
		"item": {
			"path": folder_path + "/" + item.item_name.to_lower().replace(" ", "_") + ".tres",
			"data": item.get_save_data()
		},
		"can_despawn": can_despawn,
		"despawn_time_left": $DespawnTimer.time_left
	}
	return data


func load_save_data(data : Dictionary) -> void:
	item = load(data.item.path).duplicate()
	
	item.load_save_data(data.item.data)
	can_despawn = data.can_despawn
	if can_despawn:
		$DespawnTimer.wait_time = data.despawn_time_left


func _on_despawn_timer_timeout() -> void:
	queue_free()
