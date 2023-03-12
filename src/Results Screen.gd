extends Node2D
class_name LevelResults
export(NodePath) var taste_buds_path;

signal finished_displaying_scores;
var buds:TasteBuds
var level_score;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buds = get_node(taste_buds_path);
	
func show_level_score():
	var score = 0;
	$Tween.interpolate_property(self, "modulate", Color("#00000000"), Color.white, 0.3);
	$Tween.start();
	yield(get_tree().create_timer(1), "timeout");
	buds.display_scores($Score/ScoreNumber);
	yield(buds, "finished_displaying_scores")
	score += buds.score;
	level_score = score;
	emit_signal("finished_displaying_scores")
