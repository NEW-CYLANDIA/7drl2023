extends Platform;

tool

export var lifetime:float = 1;
export var solid:bool = true setget set_solid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (not Engine.editor_hint):
		$Timer.start(lifetime);

func _process(delta: float) -> void:
	if (not Engine.editor_hint):
		var total_frames = $ClockSprite.frames.get_frame_count("default");
		$ClockSprite.frame = ($Timer.time_left / lifetime) * total_frames;

func set_solid(is_solid):
	solid = is_solid;
	$Solid.visible = solid
	$Outline.visible = not solid
	$Collision/Shape.disabled = not solid;

func resize_elements():
	.resize_elements();
	$ClockSprite.position = rect_size/2;

func _on_Container_resized() -> void:
	resize_elements();



func _on_Timer_timeout() -> void:
	if Engine.editor_hint: return;
	set_solid(!solid);
	$Timer.start(lifetime);
