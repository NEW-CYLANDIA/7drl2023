extends Node2D

var food_sprite;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	food_sprite = $FoodSprite;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node2D) -> void:
	if (body is Player):
		var player = (body as Player);
		player.enter_bubble(self);


func _on_Area2D_body_exited(body: Node) -> void:
	if (body is Player):
		var player = (body as Player);
		player.exit_bubble();
