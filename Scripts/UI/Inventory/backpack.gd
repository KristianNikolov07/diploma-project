extends GridContainer

@export var items : Array[Item]

var item_slot_scene = preload("res://Scenes/UI/Inventory/item_slot.tscn")

@onready var inventory = get_node("../Inventory")

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ToggleBackpack"):
		if visible:
			hide()
		elif items.size() > 0:
			update_backpack()
			show()


func set_inv_size(new_size : int) -> void:
	items.resize(new_size)


func add_item(item : Item) -> bool:
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item.duplicate()
			items[i].amount = item.amount
			update_backpack()
			return true
		elif items[i].item_name == item.item_name:
			var left_over = items[i].increase_amount(item.amount)
			item.decrease_amount(item.amount - left_over)
			if left_over == 0:
				update_backpack()
				return true
	return false


func has_item(item_name : String, amount = 1) -> bool:
	var count = 0
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			count += items[i].amount
	if count >= amount:
		return true
	else:
		return false


func remove_item(item_name : String, amount = 1) -> bool:
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			items[i].decrease_amount(amount)
			if items[i].amount <= 0:
				items[i] = null
			update_backpack()
			return true
	return false


func remove_item_from_slot(slot : int):
	if items[slot] != null:
		inventory.add_item(items[slot])
	update_backpack()


func is_empty() -> bool:
	for i in range(items.size()):
		if items[i] != null:
			return false
	return true


func update_backpack() -> void:
	for slot in get_children():
		slot.queue_free()
	
	for i in items.size():
		var slot = item_slot_scene.instantiate()
		slot.set_item(items[i])
		slot.name = str(i)
		slot.is_in_backpack = true
		add_child(slot)
	
