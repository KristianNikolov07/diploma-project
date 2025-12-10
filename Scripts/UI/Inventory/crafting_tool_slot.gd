extends Control

@export var tool : Recipe.CraftingTool

@onready var crafting_menu = get_node("../../")

func _on_texture_button_pressed() -> void:
	crafting_menu.select_tool(tool)
