extends Control
var crafting_recipe_scene = preload("res://Scenes/UI/Inventory/crafting_recipe_ui.tscn")
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

var selected_recipe : Recipe

@onready var player : Player = get_node("../../")


func _ready() -> void:
	hide()
	load_recipes()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenCraftingUI"):
		selected_recipe = null
		visible = !visible
		if visible:
			player.can_move = false
		else:
			player.can_move = true
		update_ui()

func load_recipes():
	for file in DirAccess.get_files_at("res://Resources/Recipes"):
		var file_name = file.replace(".remap", "")
		var recipe = load("res://Resources/Recipes/" + file_name)
		var crafting_recipe_ui = crafting_recipe_scene.instantiate()
		crafting_recipe_ui.recipe = recipe
		$Recipes/VBoxContainer.add_child(crafting_recipe_ui)
		crafting_recipe_ui.recipe_selected.connect(select_recipe)

func craft(recipe : Recipe):
	if player.has_item(recipe.item1.item_name) and player.has_item(recipe.item2.item_name):
		player.remove_item(recipe.item1.item_name)
		player.remove_item(recipe.item2.item_name)
		
		if !player.add_item(recipe.result):
			var dropped_item = dropped_item_scene.instantiate()
			dropped_item.item = recipe.result
			dropped_item.global_position = player.global_position
			get_tree().current_scene.add_child(dropped_item)

func select_recipe(recipe : Recipe):
	selected_recipe = recipe
	update_ui()

func update_ui():
	if selected_recipe == null:
		$CraftingSlot1.set_item(null)
		$CraftingSlot2.set_item(null)
		$Result.set_item(null)
		$Craft.disabled = true
	else:
		$CraftingSlot1.set_item(selected_recipe.item1, player.has_item(selected_recipe.item1.item_name))
		$CraftingSlot2.set_item(selected_recipe.item2, player.has_item(selected_recipe.item2.item_name))
		$Result.set_item(selected_recipe.result)
	
		if player.has_item(selected_recipe.item1.item_name) and player.has_item(selected_recipe.item2.item_name):
			$Craft.disabled = false
		else:
			$Craft.disabled = true


func _on_craft_pressed() -> void:
	craft(selected_recipe)
