extends Control

signal closed

func _ready() -> void:
	hide()


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func _on_language_selected(index: int) -> void:
	if index == 0:
		pass
	elif index == 1:
		pass


func _on_volume_changed() -> void:
	AudioServer.set_bus_volume_linear(0, $Settings/Volume/HSlider.value)


func _on_mods_pressed() -> void:
	pass # Replace with function body.
