extends PanelContainer

signal close

var unsaved_changes = false

func _ready() -> void:
	hide()


func open() -> void:
	show()
	set_to_default_colors()
	load_from_file()


func set_to_default_colors() -> void:
	%HairSliders.set_color(%PlayerSprite.DEFAULT_HAIR_COLOR)
	%SkinSliders.set_color(%PlayerSprite.DEFAULT_SKIN_COLOR)
	%ShirtSliders.set_color(%PlayerSprite.DEFAULT_SHIRT_COLOR)


func load_from_file() -> void:
	var config = ConfigFile.new()
	var err = config.load(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	if err != OK:
		return
	var hair = config.get_value("colors", "hair_color", %PlayerSprite.DEFAULT_HAIR_COLOR)
	var skin = config.get_value("colors", "skin_color", %PlayerSprite.DEFAULT_SKIN_COLOR)
	var shirt = config.get_value("colors", "shirt_color", %PlayerSprite.DEFAULT_SHIRT_COLOR)
	%HairSliders.set_color(hair)
	%SkinSliders.set_color(skin)
	%ShirtSliders.set_color(shirt)
	set_unsaved_changes(false)


func set_unsaved_changes(_unsaved_changes : bool) -> void:
	unsaved_changes = _unsaved_changes
	%Save.disabled = !unsaved_changes


func _on_save_pressed() -> void:
	var config = ConfigFile.new()
	config.load(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	config.set_value("colors", "hair_color", %HairSliders.get_color())
	config.set_value("colors", "skin_color", %SkinSliders.get_color())
	config.set_value("colors", "shirt_color", %ShirtSliders.get_color())
	config.save(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	set_unsaved_changes(false)


func _on_reset_to_default_pressed() -> void:
	set_to_default_colors()


func _on_close_pressed() -> void:
	hide()
	close.emit()


func _on_hair_sliders_color_changed() -> void:
	set_unsaved_changes(true)


func _on_skin_sliders_color_changed() -> void:
	set_unsaved_changes(true)


func _on_shirt_sliders_color_changed() -> void:
	set_unsaved_changes(true)
