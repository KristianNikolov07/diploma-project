extends Control

@onready var player : Player = get_node("../../")
var item_slot_scene = preload("res://Scenes/UI/Inventory/item_slot.tscn")
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")
var inventory : Array[Item]
var inventory_size = 4
var selected_slot = 0

func _ready() -> void:
	inventory.resize(inventory_size)
	initiate_inventory(inventory_size)

# UI
func initiate_inventory(slots : int):
	for i in range(slots):
		var node = item_slot_scene.instantiate()
		node.name = str(i)
		$Inventory.add_child(node)
	$"Inventory/0".select()

func visualize_inventory():
	for i in range(inventory.size()):
		$Inventory.get_node(str(i)).set_item(inventory[i])


func add_item(item : Item):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item.duplicate()
			inventory[i].amount = item.amount
			visualize_inventory()
			select_slot(selected_slot) # In case it's a weapon
			return true
		elif inventory[i].item_name == item.item_name:
			var left_over = inventory[i].increase_amount(item.amount)
			item.decrease_amount(item.amount - left_over)
			if left_over == 0:
				visualize_inventory()
				return true
	return false

func has_item(item_name : String, amount = 1):
	var count = 0
	for i in range(inventory_size):
		if inventory[i] != null and inventory[i].item_name == item_name:
			count += inventory[i].amount
	if count >= amount:
		return true
	else:
		return false

func remove_item(item_name : String, amount = 1):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].item_name == item_name:
			inventory[i].decrease_amount(amount)
			if inventory[i].amount <= 0:
				inventory[i] = null
			visualize_inventory()
			return true
	return false

func remove_item_from_slot(slot : int, amount = 1):
	if inventory[slot] != null:
		inventory[slot].decrease_amount(amount)
		if inventory[slot].amount <= 0:
			inventory[slot] = null
		visualize_inventory()
		return true

func select_slot(slot : int):
	if slot < inventory_size:
		for i in range($Inventory.get_child_count()):
			$Inventory.get_node(str(i)).deselect()
			$Inventory.get_node(str(slot)).select()
		selected_slot = slot
	
	
	for child in player.get_node("WeaponsAndTools").get_children():
		child.queue_free()
		
	#Weapons
	if inventory[slot] is Weapon:
		var weapon : Weapon = inventory[slot]
		var weapon_node = weapon.weapon_scene.instantiate()
		player.get_node("WeaponsAndTools").add_child(weapon_node)
	
	#Tools
	if inventory[slot] is Tool:
		var tool : Tool = inventory[slot]
		var tool_node = tool.tool_scene.instantiate()
		player.get_node("WeaponsAndTools").add_child(tool_node)
		
	

func drop_item(slot : int, drop_all = false):
	if inventory[slot] != null:
		var node = dropped_item_scene.instantiate()
		node.item = inventory[slot].duplicate()
		if drop_all:
			node.item.amount = inventory[slot].amount
		node.global_position = global_position
		player.get_parent().add_child(node)
		if drop_all:
			remove_item_from_slot(slot, inventory[slot].amount)
		else:
			remove_item_from_slot(slot, 1)
		
		select_slot(selected_slot) # In case it's a weapon

func use_item(slot : int):
	if player.can_move:
		if inventory[slot] != null:
			if inventory[slot] is Consumable:
				inventory[slot].use(get_node("."))
				if !inventory[slot].has_unlimited_uses:
					remove_item_from_slot(slot)
