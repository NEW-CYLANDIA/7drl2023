extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(String, FILE) var level_to_load;
export var enabled = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (enabled):
		var level_instance = load(level_to_load).instance();
		add_child(level_instance);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
