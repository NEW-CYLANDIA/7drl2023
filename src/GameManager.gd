extends Node2D
class_name GameManager
var score = 0;
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;
	
func do_game_over():
	get_tree().paused = true;
	$UILayer/RunResults.show();

func do_level_over():
	get_tree().paused = true;
	score += $UILayer/Results.show_and_return_level_score();
	load_next_level();
	get_tree().paused = false;
func load_next_level():
	pass;
