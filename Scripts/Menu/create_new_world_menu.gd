extends Control

func _ready() -> void:
	hide()


func _on_world_name_text_changed(new_text: String) -> void:
	if new_text.replace(" ", "") != "":
		$VBoxContainer/CreateNewWorld.disabled = false
	else:
		$VBoxContainer/CreateNewWorld.disabled = true


func _on_create_new_world_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	hide()
