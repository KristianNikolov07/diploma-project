extends Structure

@export var items : Array[Item]

@onready var player : Player = get_tree().get_first_node_in_group("Player")


func open() -> void:
	if player.can_move:
		$CanvasLayer/Storage.open()
		player.can_move = false
		player.inventory.opened_storage = $CanvasLayer/Storage
