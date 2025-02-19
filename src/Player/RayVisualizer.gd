extends RayCast2D

export var dash_size : float = 3.0
export var space_size : float = 3.0

export (NodePath) var primary_ray_path

var primary_ray


func _ready():
	if primary_ray_path:
		primary_ray = get_node(primary_ray_path)


func _process(_delta):
	update()


func _draw():
	if is_colliding():
		draw_circle(
			to_local(get_collision_point()),
			8,
			Color.green if get_parent().get_node("GrappleCooldown").is_stopped() else Color.red
		)
		draw_dashed_line(Vector2.ZERO, to_local(get_collision_point()), Color("#99ffffff"), 8.0)
	else:
		draw_dashed_line(Vector2.ZERO, cast_to, Color("#22ffffff"), 8.0)
func draw_dashed_line(from : Vector2, to : Vector2, color : Color, width : float):
	var line = (to-from)
	var dir = line.normalized()
	var draw_point:Vector2 = from

	for _i in range (0, round(line.length() / (dash_size + space_size))):
		draw_line(draw_point, draw_point + dir * dash_size, color, width)
		draw_point += dir * dash_size
		draw_point += dir * space_size
