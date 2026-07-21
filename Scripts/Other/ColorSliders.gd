extends VBoxContainer

signal color_changed

@export var sprites : Array[Sprite2D]

var h : float = 0
var s : float = 0
var v : float = 0

func set_h(_h : float) -> void:
	$Hue.value = _h
	h = _h
	apply_color()


func set_s(_s : float) -> void:
	$Saturation.value = _s
	s = _s
	apply_color()


func set_v(_v : float) -> void:
	$Value.value = _v
	v = _v
	apply_color()


func get_color() -> Color:
	return Color.from_hsv(h, s, v)


func apply_color() -> void:
	for sprite in sprites:
		sprite.self_modulate = Color.from_hsv(h, s, v)
	color_changed.emit()


func set_color(color : Color) -> void:
	set_h(color.h)
	set_s(color.s)
	set_v(color.v)


func _on_hue_value_changed(value: float) -> void:
	set_h(value)


func _on_saturation_value_changed(value: float) -> void:
	set_s(value)


func _on_value_value_changed(value: float) -> void:
	set_v(value)
