extends Control

var item_slot_scene = preload("res://Scenes/UI/Inventory/item_slot.tscn")

func initiate_inventory(slots : int):
	for i in range(slots):
		var node = item_slot_scene.instantiate()
		node.name = str(i)
		$Inventory.add_child(node)
	$"Inventory/0".select()

func visualize_inventory(inventory : Array[Item]):
	for i in range(inventory.size()):
		$Inventory.get_node(str(i)).set_item(inventory[i])


func select_slot(slot : int):
	for i in range($Inventory.get_child_count()):
		$Inventory.get_node(str(i)).deselect()
	$Inventory.get_node(str(slot)).select()
