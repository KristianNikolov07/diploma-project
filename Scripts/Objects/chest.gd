extends Structure

@export var items : Array[Item]

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	$CanvasLayer/GridContainer.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if $CanvasLayer/GridContainer.visible:
			$CanvasLayer/GridContainer.hide()
			player.can_move = true


func open() -> void:
	if player.can_move:
		$CanvasLayer/GridContainer.show()
		player.can_move = false
