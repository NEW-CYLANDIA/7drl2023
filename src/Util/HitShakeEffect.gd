extends Node
class_name HitShake
signal done_shaking;
var target:Node2D
var is_shaking = false;
var current_power = 10;
var current_start_power;
var current_dropoff = 1;
var current_length;
var timer;
var target_original_pos;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent() as Node2D;
	target_original_pos = target.position;

func _process(delta: float) -> void:
	if (is_shaking):
		var new_pos:Vector2 = Vector2.ONE * current_power;
		new_pos = new_pos.rotated(deg2rad(rand_range(0, 360)))
		target.position = target_original_pos + new_pos;
		timer -= delta;
		current_power = MathUtil.map_range(timer, 0, current_length, 0, current_start_power);
		if (timer <= 0):
			target.position = target_original_pos;
			is_shaking = false;5
			emit_signal("done_shaking");

func do_shake(length, power=2):
	target_original_pos = target.position;
	is_shaking = true;
	current_power = power;
	current_start_power = power;
	current_length = length;
	timer = length;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
