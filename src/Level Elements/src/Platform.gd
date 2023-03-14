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
#	Ice,
#	Electricity
}

var enum_to_flavor = [
	"Sweet",
	"Sour",
	"Savory",
	"Bitter",
	"Salty",
	"None"
]


export(PlatformType) var type:int = PlatformType.Normal;

export(PlatformFlavor) var flavor;

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

func shuffle_platform():
	type = round(rand_range(0, PlatformType.size()-1))
	flavor = round(rand_range(0, PlatformFlavor.size()-2));
	print("Type: " + str(type))
	print("Flavor: " + str(flavor));
	
	for i in range(0, 2):
		# we reroll this once to make it a bit easier
		if (type != PlatformType.Flavor):
			type = round(rand_range(0, PlatformType.size()-1))
		else: 
			break;

	update_visuals();

func update_visuals():
	if (Engine.editor_hint and sprites.size() == 0):
		for path in sprite_paths:
			sprites.append(get_node(path));
	
	for s in sprites:
		s.visible = false;
	if (sprites.size() < 8):
		return;
	if type == PlatformType.Normal:
		print("setting to normal");
		$Normal.visible = true;
#	if type == PlatformType.Ice:
#		print("setting to ice");
#		$Ice.visible = true;
#	if type == PlatformType.Electricity:
#		print("setting to electricity");
#		$Thunder.visible = true;
	if type == PlatformType.Flavor:
		print("setting to flavor...");
		if flavor == PlatformFlavor.Sweet:
			print("setting to sweet");
			$Sweet.visible = true;
		if flavor == PlatformFlavor.Salty:
			print("Setting to salty");
			$Salty.visible = true;
		if flavor == PlatformFlavor.Savory:
			print("setting to savory");
			$Umami.visible = true;
		if flavor == PlatformFlavor.Sour:
			print("setting to sour");
			$Sour.visible = true;
		if flavor == PlatformFlavor.Bitter:
			print("setting to bitter");
			$Bitter.visible = true;
			

func is_electric():
	return false;
	return type == PlatformType.Electricity;
func is_ice():
	return false;
	return type == PlatformType.Ice;
func get_flavor():
	if (type == PlatformType.Flavor):
		return enum_to_flavor[flavor]
	else: return ""

	

func _on_Platform_focus_entered() -> void:
	resize_elements();


func _on_Platform_resized() -> void:
	resize_elements();
