extends Container
class_name Platform
tool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;

func resize_elements():
	($Collision/Shape.shape as RectangleShape2D).extents = rect_size/2 - Vector2.ONE * 4;
	$Collision.position = rect_size/2;
