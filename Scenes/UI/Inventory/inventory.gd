extends Control

var item_slot_scene = preload("res://Scenes/UI/Inventory/item_slot.tscn")

func initiate_inventory(slots : int):
	for i in range(slots):
		var node = item_slot_scene.instantiate()
		node.name = str(i)
		$Inventory.add_child(node)

func visualize_inventory(inventory : Array[Item]):
	for i in range(inventory.size()):
		$Inventory.get_node(str(i)).set_item(inventory[i])
