class_name Player
extends CharacterBody2D

@export var can_move = true
@export var max_hp = 100
@export var placement_range = 200

@export_group("Speed and Stamina")
@export var base_speed = 200
@export var running_speed_gain = 5
@export var max_running_speed = 400 
@export var max_stamina = 200
@export var stamina_decrease_per_second = 0.5
@export var stamina_recharge_per_second = 0.25

var is_running = false

@onready var speed = base_speed
@onready var stamina = max_stamina
@onready var hp = max_hp
@onready var inventory = $UI/Inventory
@onready var hp_bar = $UI/Stats/HP
@onready var hunger_and_thirst = $HungerAndThirst

func _ready() -> void:
	$Stamina.max_value = max_stamina
	$Stamina.value = max_stamina
	$Stamina.hide()
	
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	


func _process(_delta: float) -> void:
	if can_move:
		velocity = Input.get_vector("Left", "Right", "Up", "Down") * speed
		
		# Running
		if Input.is_action_pressed("Sprint") and stamina > 0 and $HungerAndThirst.can_sprint():
			is_running = true
			speed += speed / running_speed_gain
			if speed > max_running_speed:
				speed = max_running_speed
		else:
			is_running = false
			speed = base_speed
		
		move_and_slide()
	
	# Stamina
	if is_running and velocity != Vector2.ZERO:
		stamina -= stamina_decrease_per_second
	elif velocity != Vector2.ZERO: # Walking
		stamina += stamina_recharge_per_second
		if stamina > max_stamina:
			stamina = max_stamina
	else: # Standing still
		stamina += stamina_recharge_per_second * 2
		if stamina > max_stamina:
			stamina = max_stamina
	if stamina != max_stamina:
		$Stamina.show()
		$Stamina.value = stamina
	else:
		$Stamina.hide()
	
	# Structure Preview
	if inventory.items[inventory.selected_slot] is StructureItem:
		if abs(global_position.x - get_global_mouse_position().x) < placement_range:
			$StructurePreview.global_position.x = get_global_mouse_position().x
		if abs(global_position.y - get_global_mouse_position().y) < placement_range:
			$StructurePreview.global_position.y = get_global_mouse_position().y

func _input(event: InputEvent) -> void:
	# Inventory
	if event.is_action_pressed("Attack"):
		attack(inventory.selected_slot)
	if event.is_action_pressed("Place"):
		place(inventory.selected_slot)
	
	#Interactions
	elif event.is_action_pressed("Interact"):
		if $InteractionRange.get_overlapping_areas().size() > 0:
			$InteractionRange.get_overlapping_areas()[0].interact(get_node("."))


func damage(damage : int) -> void:
	hp -= damage
	hp_bar.value = hp
	if hp <= 0:
		respawn()


func heal(_hp : int) -> void:
	hp += _hp
	if hp > max_hp:
		hp = max_hp
	hp_bar.value = hp


func set_hp(_hp : int) -> void:
	hp = _hp
	hp_bar.value = hp


func respawn() -> void:
	global_position = get_node("../SpawnPoints").get_child(0).global_position
	set_hp(max_hp)
	speed = base_speed
	stamina = max_stamina
	$HungerAndThirst.set_hunger($HungerAndThirst.max_hunger)


func attack(slot : int) -> void:
	if can_move:
		if inventory.items[slot] is Tool:
			if inventory.items[slot].durability > 0:
				$Tools.get_child(0).use()


func place(slot : int) -> void:
	if can_move:
		if inventory.items[slot] is StructureItem:
			if $StructurePreview.get_overlapping_bodies().size() == 0:
				inventory.items[slot].place(self, $StructurePreview.global_position)
				inventory.remove_item_from_slot(slot)
				inventory.reselect_slot()


# Debug
func list_items() -> void:
	for i in range(inventory.items.size()):
		print("Item " + str(i) + ":")
		if inventory.items[i] == null:
			print("null")
		else:
			print("Name: " + inventory.items[i].item_name)
			print("Amount: " + str(inventory.items[i].amount) + "/" + str(inventory.items[i].max_amount))


func _on_add_test_item_pressed() -> void:
	var test_item = load("res://Resources/Items/test_item.tres")
	if inventory.add_item(test_item.duplicate()) == true:
		print("Successfully added a test item")
	else:
		print("Unable to add a test item")


func _on_remove_test_item_pressed() -> void:
	if inventory.remove_item("test test") == true:
		print("Successfully removed a test item")
	else:
		print("Unable to remove a test item")


func _on_add_test_consumable_pressed() -> void:
	var test_item = load("res://Resources/Items/Consumables/test_consumable.tres")
	if inventory.add_item(test_item.duplicate()) == true:
		print("Successfully added a test consumable")
	else:
		print("Unable to add a test consumable")


func _on_debug_add_basic_sword() -> void:
	var sword = load("res://Resources/Items/Weapons/test_weapon.tres")
	if inventory.add_item(sword.duplicate()) == true:
		print("Successfully added a test sword")
	else:
		print("Unable to add a test sword")


func _on_debug_damage_player_pressed() -> void:
	damage(10)


func _on_debug_heal_player_pressed() -> void:
	heal(10)
