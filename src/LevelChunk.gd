extends Node2D


export(Array, Vector2) var exits;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().name != "LevelGenerator":
		$PlayerSpawn.spawn_test_nodes()
