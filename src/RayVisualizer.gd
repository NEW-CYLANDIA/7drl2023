extends RayCast2D

export var dash_size:float = 3.0;
export var space_size:float = 3.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update();


func _draw():
	if get_parent().state != get_parent().State.Swinging:
		var draw_point = cast_to;
		if is_colliding():
			draw_circle(to_local(get_collision_point()), 4, Color.green)
			draw_dashed_line(Vector2.ZERO, to_local(get_collision_point()), Color("#99ffffff"), 4.0);
		else:
			draw_dashed_line(Vector2.ZERO, cast_to, Color("#66ffffff"), 3.0)
	
func draw_dashed_line(from:Vector2, to:Vector2, color:Color, width:float):
	var line = (to-from);
	var dir = line.normalized();
	var draw_point:Vector2 = from;
	var is_drawing_dash = true;
	for i in range (0, round(line.length() / (dash_size + space_size))):
		draw_line(draw_point, draw_point + dir * dash_size, color, width);
		draw_point += dir * dash_size
		draw_point += dir * space_size;
