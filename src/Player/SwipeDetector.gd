extends Node2D

# pulled this from gdquest
signal swiped(direction)
signal swipe_canceled(start_position)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3;


onready var timer = $SwipeTimer;
var swipe_start_pos = Vector2();
# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			_start_detection(event.position)
		elif not timer.is_stopped():
			_end_detection(event.position);

func _start_detection(position):
	swipe_start_pos = position;
	timer.start();
	
func _end_detection(position):
	timer.stop();
	var direction = (position - swipe_start_pos).normalized();
	emit_signal("swiped", direction);
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_SwipeTimer_timeout() -> void:
	pass # Replace with function body.
