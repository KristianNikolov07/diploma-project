extends CanvasLayer

signal list_inventory_pressed
signal add_test_item_pressed
signal remove_test_item_pressed
signal add_test_consumable_pressed

func _ready() -> void:
	$Debug.hide()

func _input(event: InputEvent) -> void:
	if "debug" in OS.get_cmdline_args():
		if event.is_action_pressed("Debug"):
			$Debug.visible = !$Debug.visible

func _on_list_inventory_pressed() -> void:
	list_inventory_pressed.emit()


func _on_add_test_item_pressed() -> void:
	add_test_item_pressed.emit()


func _on_remove_test_item_pressed() -> void:
	remove_test_item_pressed.emit()


func _on_add_test_consumable_pressed() -> void:
	add_test_consumable_pressed.emit()
