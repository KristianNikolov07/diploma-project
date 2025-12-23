extends Control

signal closed

const world_option_scene = preload("res://Scenes/Menu/world_option.tscn")

func _ready() -> void:
	hide()
	get_worlds()


func get_worlds() -> void:
	for world in SaveProgress.get_saves():
		var world_option = world_option_scene.instantiate()
		world_option.world_name = world
		$Worlds/VBoxContainer.add_child(world_option)


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func _on_create_new_world_pressed() -> void:
	$CreateNewWorldMenu.show()
