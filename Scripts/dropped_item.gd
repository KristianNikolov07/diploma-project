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
	var type : String
	if item is Tool:
		type = "Tool"
	elif item is StructureItem:
		type = "StructureItem"
	elif item is Consumable:
		type = "Consumable"
	else:
		type = "Item"
	
	var data = {
		"item": {
			"type": type,
			"data": item.get_save_data()
		},
		"can_despawn": can_despawn,
		"despawn_time_left": $DespawnTimer.time_left
	}
	return data


func load_save_data(data : Dictionary) -> void:
	if data.item.type == "Item":
		item = Item.new()
	elif data.item.type == "Tool":
		item = Tool.new()
	elif data.item.type == "Consumable":
		item = Consumable.new()
	elif data.item.type == "StructureItem":
		item = StructureItem.new()
		
	item.load_save_data(data.item.data)
	
	can_despawn = data.can_despawn
	$DespawnTimer.wait_time = data.despawn_time_left


func _on_despawn_timer_timeout() -> void:
	queue_free()
