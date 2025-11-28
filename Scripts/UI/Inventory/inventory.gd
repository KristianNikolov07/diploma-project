extends Control

@export var items : Array[Item]
@export var inventory_size = 4
@export var armor : Armor

var item_slot_scene = preload("res://Scenes/UI/Inventory/item_slot.tscn")
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")
var selected_slot = 0

@onready var player = get_node("../../")

func _ready() -> void:
	items.resize(inventory_size)
	initiate_inventory_UI()


func _input(event: InputEvent) -> void:
	if event.is_action_released("PreviousItem"):
		if selected_slot == 0:
			select_slot(inventory_size - 1)
		else:
			select_slot(selected_slot - 1)
		print(selected_slot)
	if event.is_action_released("NextItem"):
		if selected_slot == inventory_size - 1:
			select_slot(0)
		else:
			select_slot(selected_slot + 1)
	if event.is_action_pressed("Item0"):
		select_slot(0)
	if event.is_action_pressed("Item1"):
		select_slot(1)
	if event.is_action_pressed("Item2"):
		select_slot(2)
	if event.is_action_pressed("Item3"):
		select_slot(3)
	if event.is_action_pressed("DropItem"):
		if Input.is_action_pressed("DropAll"):
			drop_item(selected_slot, true)
		else:
			drop_item(selected_slot, false)
	if event.is_action_pressed("UseItem"):
		use_item(selected_slot)


func add_item(item : Item) -> bool:
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item.duplicate()
			items[i].amount = item.amount
			visualize_inventory()
			reselect_slot()
			return true
		elif items[i].item_name == item.item_name:
			var left_over = items[i].increase_amount(item.amount)
			item.decrease_amount(item.amount - left_over)
			if left_over == 0:
				visualize_inventory()
				return true
	return false


func has_item(item_name : String, amount = 1) -> bool:
	var count = 0
	for i in range(inventory_size):
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
			visualize_inventory()
			return true
	return false


func remove_item_from_slot(slot : int, amount = 1) -> bool:
	if items[slot] != null:
		items[slot].decrease_amount(amount)
		if items[slot].amount <= 0:
			items[slot] = null
		visualize_inventory()
		return true
	else:
		return false

func select_slot(slot : int) -> void:
	if slot < inventory_size:
		selected_slot = slot
		visualize_selected_slot()
	
	# Tools
	for child in player.get_node("Tools").get_children():
		child.queue_free()
	if items[slot] is Tool:
		var tool : Tool = items[slot]
		var tool_node = tool.tool_scene.instantiate()
		player.get_node("Tools").add_child(tool_node)
		if player.get_node("Tools").get_child(0).has_signal("hit"):
			player.get_node("Tools").get_child(0).hit.connect(decrease_durability)
	
	# Structures
	if items[slot] is StructureItem:
		player.get_node("StructurePreview").show()
		player.get_node("StructurePreview/Sprite2D").texture = items[selected_slot].preview_texture
	else:
		player.get_node("StructurePreview").hide()


## Refreshes the currently selected slot
func reselect_slot():
	select_slot(selected_slot)


func drop_item(slot : int, drop_all = false) -> void:
	if items[slot] != null:
		var node = dropped_item_scene.instantiate()
		node.item = items[slot].duplicate()
		if drop_all:
			node.item.amount = items[slot].amount
		node.global_position = player.global_position
		player.get_parent().add_child(node)
		if drop_all:
			remove_item_from_slot(slot, items[slot].amount)
		else:
			remove_item_from_slot(slot, 1)
		
		visualize_selected_slot()


func decrease_durability() -> void:
	if items[selected_slot] is Tool:
		items[selected_slot].take_durability()
		visualize_inventory()


func use_item(slot : int) -> void:
	if player.can_move:
		if items[slot] != null:
			if items[slot] is Consumable:
				items[slot].use(player)
				if !items[slot].has_unlimited_uses:
					remove_item_from_slot(slot)


func set_items(_items : Array[Item]) -> void:
	items = _items
	visualize_inventory()


# UI
func initiate_inventory_UI():
	for i in range(inventory_size):
		var node = item_slot_scene.instantiate()
		node.name = str(i)
		$Inventory.add_child(node)
	$"Inventory/0".select()

func visualize_inventory():
	for i in range(items.size()):
		$Inventory.get_node(str(i)).set_item(items[i])


func visualize_selected_slot():
	for i in range($Inventory.get_child_count()):
		$Inventory.get_node(str(i)).deselect()
	$Inventory.get_node(str(selected_slot)).select()
