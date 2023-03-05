extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update();
func _draw():
	draw_line(Vector2.ZERO, cast_to, Color("#99ffffff"), 4.0);
