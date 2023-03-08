extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(Texture) var straight_tex;
export(Texture) var squiggly_tex;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_straight():
	texture = straight_tex;
func set_squiggly():
	texture = squiggly_tex;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
