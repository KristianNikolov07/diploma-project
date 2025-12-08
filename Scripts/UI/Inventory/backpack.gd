class_name BackpackSystem
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
	
