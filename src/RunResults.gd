extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Score/ScoreNumber.text = str(($root as GameManager).score);
	pass # Replace with function body.
	

func show():
	$Score/ScoreNumber.text = str(ScoreManager.current_level_score);
	$Tween.interpolate_property(self, "modulate", Color("#00000000"), Color.white, 0.3);
	$Tween.start();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_pressed() -> void:
	ScoreManager.current_level_score = 0;
	ScoreManager.current_run_score = 0;
	get_tree().paused = false;
	get_tree().reload_current_scene();
