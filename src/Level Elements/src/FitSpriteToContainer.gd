extends NinePatchRect
tool

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

#array of animatedsprites;
var sprites:Array;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize_sprite();
	
func _process(delta: float) -> void:
	resize_sprite();

# to be called by parent
func resize_sprite():
	sprites = [];
	for c in get_children():
		sprites.append(c);
	for spr in sprites:
		var tex = spr.frames.get_frame("default", 0);
		var sprite_size = tex.get_size();
		spr.scale = rect_size / sprite_size;
		spr.position = rect_size/2;


func _on_Platform_resized() -> void:
	resize_sprite()


func _on_Platform_focus_entered() -> void:
	resize_sprite();
