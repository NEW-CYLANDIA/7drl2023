extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update();


func _draw():
	if get_parent().state != get_parent().State.Swinging:
		draw_line(Vector2.ZERO, cast_to, Color("#99ffffff"), 4.0);
		if is_colliding():
			draw_circle(to_local(get_collision_point()), 4, Color.green)
