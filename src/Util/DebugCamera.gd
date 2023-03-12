extends Camera2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var speed = 200;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += dir * speed;
	if (Input.is_action_pressed("action")):
		zoom += Vector2.ONE * 0.1;
	if (Input.is_action_pressed("ui_zoom_in")):
		zoom -= Vector2.ONE * 0.1;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
