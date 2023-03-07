extends Node2D

tool

export var lifetime:float = 1;
export var solid:bool = true setget set_solid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;

func _process(delta: float) -> void:
	pass;

func set_solid(is_solid):
	solid = is_solid;
	$Container/Solid.visible = solid
	$Container/Outline.visible = not solid
	$Collision/Shape.disabled = not solid;


func _on_Container_resized() -> void:
		if (Engine.editor_hint):
			var rect_shape = ($Collision/Shape.shape) as RectangleShape2D;
			rect_shape.extents = $Container.rect_size/2;
			$Collision.position = $Container.rect_position + $Container.rect_size/2;
			$ClockSprite.position = $Container.rect_position + $Container.rect_size/2;
