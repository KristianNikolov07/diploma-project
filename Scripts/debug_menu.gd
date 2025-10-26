extends Control

func _ready() -> void:
	if "debug" in OS.get_cmdline_args():
		show()
	else:
		hide()
