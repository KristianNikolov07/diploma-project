extends Node

var config = ConfigFile.new()
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@export var save_name = ""

const saves_folder = "user://saves/"
const player_stats_file_name = "player_stats.ini"


func save():
	if save_name != "":
		print("Saving game...")
		if !DirAccess.dir_exists_absolute(saves_folder + save_name):
			DirAccess.make_dir_recursive_absolute(saves_folder + save_name)
		config.load(saves_folder + save_name + "/" + player_stats_file_name)
		config.set_value("stats", "hp", player.hp)
		config.set_value("stats", "stamina", player.stamina)
		config.set_value("stats", "speed", player.speed)
		config.set_value("stats", "position", player.global_position)
		config.set_value("inventory", "inventory", player.inventory)
		config.save(saves_folder + save_name + "/" + player_stats_file_name)

func load():
	if !DirAccess.dir_exists_absolute(saves_folder + save_name):
		DirAccess.make_dir_recursive_absolute(saves_folder + save_name)
	if config.load(saves_folder + save_name + "/" + player_stats_file_name) == OK:
		player.set_hp(config.get_value("stats", "hp", player.max_hp)) 
		player.stamina = config.get_value("stats", "stamina", player.max_stamina)
		player.speed = config.get_value("stats", "speed", player.base_speed)
		player.global_position = config.get_value("stats", "position", player.global_position)
		if config.has_section_key("inventory", "inventory"):
			player.inventory = config.get_value("inventory", "inventory")
		else:
			player.inventory.fill(null)
		player.inventory_UI.visualize_inventory(player.inventory)
