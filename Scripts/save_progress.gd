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
		config.set_value("inventory", "inventory", player.inventory)
		config.save(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME)


func load() -> void:
	if !DirAccess.dir_exists_absolute(SAVES_FOLDER + save_name):
		DirAccess.make_dir_recursive_absolute(SAVES_FOLDER + save_name)
	if config.load(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME) == OK:
		player.set_hp(config.get_value("stats", "hp", player.max_hp)) 
		player.stamina = config.get_value("stats", "stamina", player.max_stamina)
		player.speed = config.get_value("stats", "speed", player.base_speed)
		player.global_position = config.get_value("stats", "position", player.global_position)
		if config.has_section_key("inventory", "inventory"):
			player.inventory = config.get_value("inventory", "inventory")
		else:
			player.inventory.fill(null)
		player.inventory_UI.visualize_inventory(player.inventory)
