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
	$UILayer/Results.show_level_score();
	yield($UILayer/Results, "finished_displaying_scores")
	ScoreManager.current_level_score += $UILayer/Results.level_score;
	get_tree().paused = false;
	load_next_level();
	
	
func load_next_level():
	print("hyello");
	get_tree().reload_current_scene();
