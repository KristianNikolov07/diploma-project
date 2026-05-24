extends PanelContainer

signal option1_pressed
signal option2_pressed

@export var title : String
@export var description : String
@export var option1 : String
@export var option2 : String

func _ready() -> void:
	%Title.text = title
	%Description.text = description
	%Button.text = option1
	if option2 != "":
		%Button2.text = option2
	else:
		%Button2.hide()


func _on_button_pressed() -> void:
	option1_pressed.emit()
	queue_free()


func _on_button_2_pressed() -> void:
	option2_pressed.emit()
	queue_free()
