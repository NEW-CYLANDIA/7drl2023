extends NinePatchRect
tool

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

#array of animatedsprites;
var sprites:Array;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;

# to be called by parent
func resize_sprite():
	for c in get_children():
		sprites.append(c);
	for spr in sprites:
		var tex = spr.frames.get_frame("default", 0);
		var sprite_size = tex.get_size();
		spr.scale = rect_size / sprite_size;
		spr.position = rect_size/2;
