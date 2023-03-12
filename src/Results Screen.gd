extends Node2D

export(NodePath) var taste_buds_path;
var buds;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buds = get_node(taste_buds_path);
	
func show():
	yield(get_tree().create_timer(5), "timeout");
	$Tween.interpolate_property(self, "modulate", Color("#00000000"), Color.white, 0.3);
	$Tween.start();
	yield(get_tree().create_timer(1), "timeout");
	buds.display_scores($Score/ScoreNumber);
	yield(get_tree().create_timer(5), "timeout")
	print("finished displaying");
