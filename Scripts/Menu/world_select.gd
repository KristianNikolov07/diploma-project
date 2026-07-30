extends Control

signal closed

const WORLD_OPTION_SCENE = preload("res://Scenes/Menu/world_option.tscn")

func _ready() -> void:
	hide()
	get_worlds()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_back_pressed()
			accept_event()


func get_worlds() -> void:
	for world : WorldInfo in SaveProgress.get_saves():
		var world_option = WORLD_OPTION_SCENE.instantiate()
		world_option.world_name = world.world_name
		world_option.world_seed = world.world_seed
		world_option.playtime = world.playtime
		world_option.is_modded = world.is_modded
		world_option.version = world.version
		world_option.is_checksum_valid = world.is_checksum_valid
		$VBoxContainer/Worlds/MarginContainer/VBoxContainer.add_child(world_option)


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func _on_create_new_world_pressed() -> void:
	%CreateNewWorldMenu.show()
