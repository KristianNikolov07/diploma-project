extends CharacterBody2D
@export_group("Speed and Stamina")
@export var base_speed = 200
@export var running_speed_gain = 5
@export var max_running_speed = 400 
@export var max_stamina = 200
@export var stamina_decrease_rate = 1
@export var stamina_recharge_rate = 0.25
@export var sprint_stamina_requirement_percent = 50

@export_group("Inventory")
@export var inventory : Array[Item]
@export var inventory_size = 4

@onready var speed = base_speed
@onready var stamina = max_stamina

@onready var inventory_UI = $UI/Inventory


var is_running = false
var selected_slot = 0
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func _ready() -> void:
	inventory.resize(inventory_size)
	inventory_UI.initiate_inventory(inventory_size)

func _process(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down") * speed
	
	#Running
	if Input.is_action_pressed("Sprint") and stamina > 0:
		is_running = true
		speed += speed / running_speed_gain
		if speed > max_running_speed:
			speed = max_running_speed
	else:
		is_running = false
		speed = base_speed
	
	move_and_slide()
	
	#Stamina
	if is_running:
		stamina -= stamina_decrease_rate
	elif velocity != Vector2.ZERO: #Walking
		stamina += stamina_recharge_rate
		if stamina > max_stamina:
			stamina = max_stamina
	else: #Standing still
		stamina += stamina_recharge_rate * 2
		if stamina > max_stamina:
			stamina = max_stamina
	$Stamina.value = stamina / max_stamina * 100

func _input(event: InputEvent) -> void:
	#Inventory
	if event.is_action_released("PreviousItem"):
		if selected_slot == 0:
			select_slot(inventory_size - 1)
		else:
			select_slot(selected_slot - 1)
	elif event.is_action_released("NextItem"):
		if selected_slot == inventory_size - 1:
			select_slot(0)
		else:
			select_slot(selected_slot + 1)
	elif event.is_action_pressed("Item0"):
		select_slot(0)
	elif event.is_action_pressed("Item1"):
		select_slot(1)
	elif event.is_action_pressed("Item2"):
		select_slot(2)
	elif event.is_action_pressed("Item3"):
		select_slot(3)
	elif event.is_action_pressed("DropItem"):
		drop_item(selected_slot)
	elif event.is_action_pressed("UseItem"):
		use_item(selected_slot)
	
	#Interactions
	elif event.is_action_pressed("Interact"):
		if $InteractionRange.get_overlapping_areas().size() > 0:
			$InteractionRange.get_overlapping_areas()[0].interact(get_node("."))

#Inventory
func add_item(item : Item):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item.duplicate()
			inventory_UI.visualize_inventory(inventory)
			return true
		elif inventory[i].item_name == item.item_name:
			var left_over = inventory[i].increase_amount(item.amount)
			item.decrease_amount(item.amount - left_over)
			if left_over == 0:
				inventory_UI.visualize_inventory(inventory)
				return true
	return false

func remove_item(item_name : String, amount = 1):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].item_name == item_name:
			inventory[i].decrease_amount(amount)
			if inventory[i].amount <= 0:
				inventory[i] = null
			inventory_UI.visualize_inventory(inventory)
			return true
	return false

func remove_item_from_slot(slot : int, amount = 1):
	if inventory[slot] != null:
		inventory[slot].decrease_amount(amount)
		if inventory[slot].amount <= 0:
			inventory[slot] = null
		inventory_UI.visualize_inventory(inventory)
		return true

func select_slot(slot : int):
	inventory_UI.select_slot(slot)
	selected_slot = slot

func drop_item(slot : int):
	if inventory[slot] != null:
		var node = dropped_item_scene.instantiate()
		node.item = inventory[slot].duplicate()
		node.global_position = global_position
		get_parent().add_child(node)
		
		remove_item_from_slot(slot)

func use_item(slot : int):
	if inventory[slot] != null:
		if inventory[slot].has_method("use"):
			inventory[slot].use()
		if inventory[slot] is Consumable and !inventory[slot].has_unlimited_uses:
			remove_item_from_slot(slot)

func list_items():
	for i in range(inventory.size()):
		print("Item " + str(i) + ":")
		if inventory[i] == null:
			print("null")
		else:
			print("Name: " + inventory[i].item_name)
			print("Amount: " + str(inventory[i].amount) + "/" + str(inventory[i].max_amount))


func _on_add_test_item_pressed() -> void:
	var test_item = load("res://Resources/Items/test_item.tres")
	if add_item(test_item) == true:
		print("Successfully added a test item")
	else:
		print("Unable to add a test item")


func _on_remove_test_item_pressed() -> void:
	if remove_item("test test") == true:
		print("Successfully removed a test item")
	else:
		print("Unable to remove a test item")


func _on_add_test_consumable_pressed() -> void:
	var test_item = load("res://Resources/Items/Consumables/test_consumable.tres")
	if add_item(test_item) == true:
		print("Successfully added a test consumable")
	else:
		print("Unable to add a test consumable")
