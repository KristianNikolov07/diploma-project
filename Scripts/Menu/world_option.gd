extends Control

var world_name = "Test"
var delete_pressed = false

func _ready() -> void:
	$Label.text = world_name
	$Buttons/Delete/ProgressBar.max_value = $Buttons/Delete/DeleteTimer.wait_time


func _process(_delta: float) -> void:
	if $Buttons/Delete.is_pressed():
		$Buttons/Delete/ProgressBar.value = $Buttons/Delete/ProgressBar.max_value - $Buttons/Delete/DeleteTimer.time_left
	else:
		$Buttons/Delete/ProgressBar.value = 0


func _on_play_pressed() -> void:
	SaveProgress.save_name = world_name
	get_tree().change_scene_to_file("res://Scenes/Worlds/main.tscn")


func _on_delete_button_up() -> void:
	$Buttons/Delete/DeleteTimer.stop()


func _on_delete_button_down() -> void:
	if $Buttons/Delete/DeleteTimer.is_stopped():
		$Buttons/Delete/DeleteTimer.start()


func _on_delete_timer_timeout() -> void:
	SaveProgress.delete(world_name)
	queue_free()
