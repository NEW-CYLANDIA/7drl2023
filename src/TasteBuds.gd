extends Node2D

var taste_buds:Dictionary = Dictionary();
export var taste_bud_dropoff:float = 0.001;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for s in Const.FLAVORS:
		taste_buds[s] = get_node(s);
func _process(delta: float) -> void:
	for bud in taste_buds.values():
		bud.add_mood(-taste_bud_dropoff);
