extends Node2D

var taste_buds:Dictionary = Dictionary();
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for s in Const.FLAVORS:
		taste_buds[s] = get_node(s);
