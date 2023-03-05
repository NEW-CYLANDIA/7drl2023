extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw();
func _draw():
	draw_dashed_line(Vector2.ZERO, target_position, Color("#ffffff", 0.3), 1.0, 5.0, false);
