extends Container
class_name Platform
tool
enum PlatformFlavor {
	Sweet,
	Sour,
	Savory,
	Bitter,
	Salty,
	None
}
enum PlatformType {
	Normal,
	Flavor,
	Ice,
	Electricity	
}

var enum_to_flavor = [
	"Sweet",
	"Sour",
	"Savory",
	"Bitter",
	"Salty",
	"None"
]


export(PlatformType) var type:int = PlatformType.Normal setget set_type;

export(PlatformFlavor) var flavor setget set_flavor;

export(Array, NodePath) var sprite_paths:Array

var sprites:Array
var velocity:Vector2;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!Engine.editor_hint):
		for path in sprite_paths:
			sprites.append(get_node(path));
	update_visuals();
	resize_elements();

func resize_elements():
	$Collision.position = rect_size/2;
	$Collision.scale = rect_size/2 - Vector2.ONE * 200;

func set_flavor(_flavor):
	flavor = _flavor
	if (Engine.editor_hint):
		update_visuals();

func set_type(_type):
	type = _type;
	if (Engine.editor_hint):
		update_visuals();

func shuffle_platform():
	type = round(rand_range(0, PlatformType.size()-1))
	flavor = round(rand_range(0, PlatformFlavor.size()-1));
	
	# we reroll this once to make it a bit easier
	if (type != PlatformType.Flavor):
		type = round(rand_range(0, PlatformType.size()-1))
		
	if (type != PlatformType.Flavor):
		type = round(rand_range(0, PlatformType.size()-1))
		
	if (type != PlatformType.Flavor):
		type = round(rand_range(0, PlatformType.size()-1))
	update_visuals();

func update_visuals():
	if (Engine.editor_hint and sprites.size() == 0):
		for path in sprite_paths:
			sprites.append(get_node(path));
	
	for s in sprites:
		s.visible = false;
	if (sprites.size() < 8):
		print("sprites not initialized yet");
		return;
	match (type):
		PlatformType.Normal:
			$Normal.visible = true;
		PlatformType.Ice:
			$Ice.visible = true;
		PlatformType.Electricity:
			$Thunder.visible = true;
		PlatformType.Flavor:
			if flavor == PlatformFlavor.Sweet:
				$Sweet.visible = true;
			if flavor == PlatformFlavor.Salty:
				$Salty.visible = true;
			if flavor == PlatformFlavor.Savory:
				$Umami.visible = true;
			if flavor == PlatformFlavor.Sour:
				$Sour.visible = true;
			if flavor == PlatformFlavor.Bitter:
				$Bitter.visible = true;
			

func is_electric():
	return type == PlatformType.Electricity;
func is_ice():
	return type == PlatformType.Ice;
func get_flavor():
	if (type == PlatformType.Flavor):
		return enum_to_flavor[flavor]
	else: return ""
	

func _on_Platform_focus_entered() -> void:
	resize_elements();


func _on_Platform_resized() -> void:
	resize_elements();
