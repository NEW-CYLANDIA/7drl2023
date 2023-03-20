extends Node2D


# these will be given by level gen
var player:Node2D
var exit:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position = player.global_position;
	rotation = ((exit.global_position - player.global_position) as Vector2).angle();
