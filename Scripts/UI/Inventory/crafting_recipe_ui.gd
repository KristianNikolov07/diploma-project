extends Control

signal recipe_selected(recipe : Recipe)

@export var recipe : Recipe

func _ready() -> void:
	$Item1.texture = recipe.item1.texture
	$Item2.texture = recipe.item2.texture
	$Result.texture = recipe.result.texture


func _on_texture_button_pressed() -> void:
	recipe_selected.emit(recipe)
