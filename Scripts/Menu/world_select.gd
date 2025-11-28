extends Control


func _on_new_world_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/main.tscn")
