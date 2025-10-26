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
var is_running = false

func _ready() -> void:
	inventory.resize(inventory_size)

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
	elif velocity != Vector2.ZERO:
		stamina += stamina_recharge_rate
		if stamina > max_stamina:
			stamina = max_stamina
	else:
		stamina += stamina_recharge_rate * 2
		if stamina > max_stamina:
			stamina = max_stamina
	$Stamina.value = stamina / max_stamina * 100

#Inventory
func add_item(item : Item):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item.duplicate()
			return true
		elif inventory[i].item_name == item.item_name:
			var left_over = inventory[i].increase_amount(item.amount)
			item.decrease_amount(item.amount - left_over)
			if left_over == 0:
				return true
	return false

func remove_item(item_name : String, amount : int):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].item_name == item_name:
			inventory[i].decrease_amount(amount)
			if inventory[i].amount <= 0:
				inventory[i] = null
			return true
	return false

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
