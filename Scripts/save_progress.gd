extends Node

const SAVES_FOLDER = "user://saves/"
const PLAYER_STATS_FILE_NAME = "player_stats.ini"

@export var save_name = ""

var config = ConfigFile.new()

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func save() -> void:
	if save_name != "":
		print("Saving game...")
		if !DirAccess.dir_exists_absolute(SAVES_FOLDER + save_name):
			DirAccess.make_dir_recursive_absolute(SAVES_FOLDER + save_name)
		config.load(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME)
		config.set_value("stats", "hp", player.hp)
		config.set_value("stats", "stamina", player.stamina)
		config.set_value("stats", "speed", player.speed)
		config.set_value("stats", "position", player.global_position)
		config.set_value("stats", "hunger", player.hunger_and_thirst.hunger)
		config.set_value("stats", "thirst", player.hunger_and_thirst.thirst)
		config.set_value("inventory", "inventory", player.inventory.items)
		config.save(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME)


func load() -> void:
	if !DirAccess.dir_exists_absolute(SAVES_FOLDER + save_name):
		DirAccess.make_dir_recursive_absolute(SAVES_FOLDER + save_name)
	if config.load(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME) == OK:
		player.set_hp(config.get_value("stats", "hp", player.max_hp)) 
		player.stamina = config.get_value("stats", "stamina", player.max_stamina)
		player.speed = config.get_value("stats", "speed", player.base_speed)
		player.global_position = config.get_value("stats", "position", player.global_position)
		player.hunger_and_thirst.set_hunger(config.get_value("stats", "hunger", 0))
		player.hunger_and_thirst.set_thirst(config.get_value("stats", "thirst", 0))
		if config.has_section_key("inventory", "inventory"):
			player.inventory.set_items(config.get_value("inventory", "inventory"))
		else:
			player.inventory.set_items([])
