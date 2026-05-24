extends Control

const POPUP_SCENE = preload("res://Scenes/Menu/popup.tscn")

var world_name = "World"
var delete_pressed = false
var is_checksum_valid = true

func _ready() -> void:
	%WorldName.text = world_name
	%Delete/ProgressBar.max_value = %Delete/DeleteTimer.wait_time
	set_playtime()
	check_checksum()


func _process(_delta: float) -> void:
	if %Delete.is_pressed():
		%Delete/ProgressBar.value = %Delete/ProgressBar.max_value - %Delete/DeleteTimer.time_left
	else:
		%Delete/ProgressBar.value = 0


func _on_play_pressed() -> void:
	if not is_checksum_valid:
		var popup = POPUP_SCENE.instantiate()
		popup.title = "WARNING"
		popup.description = "CHECKSUM_ERROR"
		popup.option1 = "I_KNOW_WHAT_I_AM_DOING"
		popup.option2 = "CANCEL"
		popup.option1_pressed.connect(start_world)
		get_tree().current_scene.add_child(popup)
	else:
		start_world()


func start_world() -> void:
	SaveProgress.save_name = world_name
	get_tree().change_scene_to_file("res://Scenes/Menu/loading_screen.tscn")


func _on_delete_button_up() -> void:
	if has_node("%Delete"):
		%Delete/DeleteTimer.stop()


func _on_delete_button_down() -> void:
	if %Delete/DeleteTimer.is_stopped():
		%Delete/DeleteTimer.start()


func _on_delete_timer_timeout() -> void:
	SaveProgress.delete(world_name)
	queue_free()


func set_playtime() -> void:
	var playtime: int = int(SaveProgress.get_playtime(world_name))

	if playtime <= 0:
		%Playtime.hide()
		return

	%Playtime.show()

	var s = playtime
	@warning_ignore("integer_division")
	var m = s / 60
	s = s % 60
	@warning_ignore("integer_division")
	var h = m / 60
	m = m % 60
	@warning_ignore("integer_division")
	var d = h / 24
	h = h % 24

	if d > 0:
		%Playtime.text = (str(d) + " d") + ("" if h == 0 else " " + str(h) + " h")
	elif h > 0:
		%Playtime.text = (str(h) + " h") + ("" if m == 0 else " " + str(m) + " min")
	elif m > 0:
		%Playtime.text = (str(m) + " min") + ("" if s == 0 else " " + str(s) + " sec")
	else:
		%Playtime.text = str(s) + " sec"


func check_checksum():
	is_checksum_valid = SaveProgress.check_checksum(world_name)
	if not is_checksum_valid:
		%WorldName.add_theme_color_override("font_color", Color.RED)
