extends Camera2D

@export var target_path:NodePath;
@onready var target:Node2D = get_node(target_path);
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = target.position;
