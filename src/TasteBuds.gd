extends Node2D
class_name TasteBuds
var taste_buds:Dictionary = Dictionary();
export var taste_bud_dropoff:float = 0.0002;
signal finished_displaying_scores;
var score = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for s in Const.FLAVORS:
		taste_buds[s] = get_node(s);
func _process(delta: float) -> void:
	var every_bud_sad = true;
	for bud in taste_buds.values():
		bud.add_mood(-taste_bud_dropoff);
		if (bud.mood > 0):
			every_bud_sad = false;
	if (every_bud_sad):
		(get_node("/root/GameScene") as GameManager).do_game_over();
		
func display_scores(label):
	for bud in taste_buds.values():
		bud.mood_paused = true;
	for bud in taste_buds.values():
		score += bud.display_and_return_score();
		label.text = str(score);
		yield(get_tree().create_timer(0.5), "timeout");
	emit_signal("finished_displaying_scores");
	score = 0;
