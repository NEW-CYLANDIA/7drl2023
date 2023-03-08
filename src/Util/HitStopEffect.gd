extends Node
class_name HitStop

var target;
var target_original_velocity;
var current_stop_length;
var is_stopped = false;
var timer = 0;
signal done_stopping;
func _ready() -> void:
	target = get_parent();
	
func _process(delta: float) -> void:
	if (is_stopped):
		#target.velocity = Vector2.ZERO;
		timer -= delta;
		if (timer <= 0):
			get_tree().paused = false;
			is_stopped = false;
			emit_signal("done_stopping");
			# target.velocity = target_original_velocity;
		
	
func do_hit_stop(length):
	get_tree().paused = true;
	is_stopped = true;
	#target_original_velocity = target.velocity;
	#target.velocity = Vector2.ZERO;
	current_stop_length = length;
	timer = length;
