extends PanelContainer

const POPUP_SCENE = preload("res://Scenes/Menu/popup.tscn")

@export_file_path var mod_path = ""

var enabled = false
var enabled_originally = false
var version = "Unknown"

func _ready() -> void:
	# Load info
	var manifest_file = FileAccess.open(mod_path + "/" + Global.MODS_MANIFEST_FILE_NAME, FileAccess.READ)
	if manifest_file == null:
		push_error("Could not read manifest for mod: " + mod_path)
	else:
		var manifest = JSON.parse_string(manifest_file.get_as_text())
		manifest_file.close()
		if manifest is Dictionary:
			%Name.text = manifest.get("name", "Unknown")
			%Author.text = "By " + manifest.get("author", "Unknown")
			version = manifest.get("version", "Unknown")
			if version != ProjectSettings.get_setting("application/config/version"):
				%Name.add_theme_color_override("font_color", Color.RED)
		else:
			push_error("Invalid manifest JSON for mod: " + mod_path)

	# Check if enabled
	var enabled_check_file = FileAccess.open(mod_path + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME, FileAccess.READ)
	if enabled_check_file == null:
		push_error("Could not read enable check file for mod: " + mod_path)
	else:
		if enabled_check_file.get_var() == true:
			%ToggleMod.button_pressed = true
			enabled = true
			enabled_originally = true
		enabled_check_file.close()
	
	%RemoveMod/ProgressBar.max_value = %RemoveMod/DeleteTimer.wait_time


func _process(_delta: float) -> void:
	if %RemoveMod.is_pressed():
		%RemoveMod/ProgressBar.value = %RemoveMod/ProgressBar.max_value - %RemoveMod/DeleteTimer.time_left
	else:
		%RemoveMod/ProgressBar.value = 0


func show_version_warning() -> void:
	var popup = POPUP_SCENE.instantiate()
	popup.title = "WARNING"
	popup.description = tr("MOD_FOR_DIFFERENT_VERSION_WARNING")
	if version != "Unknown":
		version += "\n[url=https://github.com/KristianNikolov07/stranded-shores/releases/tag/v." + version + "]Download v" + version + "[/url]"
	popup.option1 = "I_KNOW_WHAT_I_AM_DOING"
	popup.option2 = "CANCEL"
	popup.option1_pressed.connect(enable_mod)
	get_tree().current_scene.add_child(popup)


func _on_toggle_mod_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if version != ProjectSettings.get_setting("application/config/version"):
			%ToggleMod.button_pressed = false
			show_version_warning()
		else:
			enable_mod()
	else:
		disable_mod()


func enable_mod() -> void:
	var enabled_check_file = FileAccess.open(mod_path + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME, FileAccess.WRITE)
	enabled_check_file.store_var(true)
	enabled_check_file.close()
	enabled = true
	%ToggleMod.text = tr("DISABLE")
	%ToggleMod.set_pressed_no_signal(true)


func disable_mod() -> void:
	var enabled_check_file = FileAccess.open(mod_path + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME, FileAccess.WRITE)
	enabled_check_file.store_var(false)
	enabled_check_file.close()
	enabled = false
	%ToggleMod.text = tr("ENABLE")
	%ToggleMod.set_pressed_no_signal(false)


func _on_remove_mod_button_down() -> void:
	if %RemoveMod/DeleteTimer.is_stopped():
		%RemoveMod/DeleteTimer.start()


func _on_remove_mod_button_up() -> void:
	if %RemoveMod != null:
		%RemoveMod/DeleteTimer.stop()


func _on_delete_timer_timeout() -> void:
	DirAccess.remove_absolute(mod_path + "/mod.pck")
	DirAccess.remove_absolute(mod_path + "/" + Global.MODS_MANIFEST_FILE_NAME)
	DirAccess.remove_absolute(mod_path + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME)
	DirAccess.remove_absolute(mod_path)
	queue_free()
