class_name Player
extends CharacterBody2D
@export var can_move = true

@export var max_hp = 100

@export_group("Speed and Stamina")
@export var base_speed = 200
@export var running_speed_gain = 5
@export var max_running_speed = 400 
@export var max_stamina = 200
@export var stamina_decrease_rate = 1
@export var stamina_recharge_rate = 0.25

@export_group("Inventory")
@export var inventory : Array[Item]
@export var inventory_size = 4

@onready var speed = base_speed
@onready var stamina = max_stamina
@onready var hp = max_hp

@onready var inventory_UI = $UI/Inventory


var is_running = false
var selected_slot = 0
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func _ready() -> void:
	$Stamina.max_value = max_stamina
	$Stamina.value = max_stamina
	
	$HP.max_value = max_hp
	$HP.value = hp
	
	inventory.resize(inventory_size)
	inventory_UI.initiate_inventory(inventory_size)

func _process(delta: float) -> void:
	if can_move:
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
	if is_running and velocity != Vector2.ZERO:
		stamina -= stamina_decrease_rate
	elif velocity != Vector2.ZERO: #Walking
		stamina += stamina_recharge_rate
		if stamina > max_stamina:
			stamina = max_stamina
	else: #Standing still
		stamina += stamina_recharge_rate * 2
		if stamina > max_stamina:
			stamina = max_stamina
	$Stamina.value = stamina

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
		if Input.is_action_pressed("DropAll"):
			drop_item(selected_slot, true)
		else:
			drop_item(selected_slot, false)
	elif event.is_action_pressed("UseItem"):
		use_item(selected_slot)
	elif event.is_action_pressed("Attack"):
		attack(selected_slot)
	
	#Interactions
	elif event.is_action_pressed("Interact"):
		if $InteractionRange.get_overlapping_areas().size() > 0:
			$InteractionRange.get_overlapping_areas()[0].interact(get_node("."))
#Health
func damage(damage : int):
	hp -= damage
	$HP.value = hp
	if hp <= 0:
		respawn()

func heal(_hp : int):
	hp += _hp
	if hp > max_hp:
		hp = max_hp
	$HP.value = hp
	
func respawn():
	global_position = get_node("../SpawnPoints").get_child(0).global_position
	hp = max_hp
	speed = base_speed
	stamina = max_stamina
	

#Inventory
func add_item(item : Item):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item.duplicate()
			inventory[i].amount = item.amount
			inventory_UI.visualize_inventory(inventory)
			select_slot(selected_slot) # In case it's a weapon
			return true
		elif inventory[i].item_name == item.item_name:
			var left_over = inventory[i].increase_amount(item.amount)
			item.decrease_amount(item.amount - left_over)
			if left_over == 0:
				inventory_UI.visualize_inventory(inventory)
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
	if slot < inventory_size:
		inventory_UI.select_slot(slot)
		selected_slot = slot
	
	
	for child in $WeaponsAndTools.get_children():
		child.queue_free()
		
	#Weapons
	if inventory[slot] is Weapon:
		var weapon : Weapon = inventory[slot]
		var weapon_node = weapon.weapon_scene.instantiate()
		$WeaponsAndTools.add_child(weapon_node)
	
	#Tools
	if inventory[slot] is Tool:
		var tool : Tool = inventory[slot]
		var tool_node = tool.tool_scene.instantiate()
		$WeaponsAndTools.add_child(tool_node)
		
	

func drop_item(slot : int, drop_all = false):
	if inventory[slot] != null:
		var node = dropped_item_scene.instantiate()
		node.item = inventory[slot].duplicate()
		if drop_all:
			node.item.amount = inventory[slot].amount
		node.global_position = global_position
		get_parent().add_child(node)
		if drop_all:
			remove_item_from_slot(slot, inventory[slot].amount)
		else:
			remove_item_from_slot(slot, 1)
		
		select_slot(selected_slot) # In case it's a weapon

func use_item(slot : int):
	if can_move:
		if inventory[slot] != null:
			if inventory[slot] is Consumable:
				inventory[slot].use(get_node("."))
				if !inventory[slot].has_unlimited_uses:
					remove_item_from_slot(slot)

func attack(slot : int):
	if can_move:
		if inventory[slot] is Weapon or inventory[slot] is Tool:
			if !inventory[slot].broken:
				var hit = await $WeaponsAndTools.get_child(0).use()
				if hit:
					inventory[slot].take_durability()
					inventory_UI.visualize_inventory(inventory)


# Debug
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
	if add_item(test_item.duplicate()) == true:
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
	if add_item(test_item.duplicate()) == true:
		print("Successfully added a test consumable")
	else:
		print("Unable to add a test consumable")


func _on_debug_add_basic_sword() -> void:
	var sword = load("res://Resources/Items/Weapons/test_sword.tres")
	if add_item(sword.duplicate()) == true:
		print("Successfully added a test sword")
	else:
		print("Unable to add a test sword")


func _on_debug_damage_player_pressed() -> void:
	damage(10)


func _on_debug_heal_player_pressed() -> void:
	heal(10)
