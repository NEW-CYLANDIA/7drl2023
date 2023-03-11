extends PanelContainer
tool
export(Array, NodePath) var node_paths;
export var speed:float = 10;
var nodes:Array;
var current_node:Node2D;
var current_node_index:int = -1;
var velocity:Vector2;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for path in node_paths:
		nodes.append(get_node(path));
	
	set_next_node();
		
func _process(delta: float) -> void:
	if (Engine.editor_hint):
		update();
	else:
		var dest = current_node.position - (rect_size * rect_scale)/2;
		$Platform/Collision.velocity = (dest - rect_position).normalized() * speed;
		rect_position = rect_position.move_toward(dest, speed);
		if (rect_position.distance_to(dest) < 1):
			set_next_node();
		
func _draw() -> void:
	if (Engine.editor_hint):
		var line_color = Color("#55ffffff")
		for i in range(0, nodes.size()):
			if (i == 0):
				draw_line(nodes[nodes.size()-1].position - rect_position, nodes[i].position - rect_position, line_color, 4);
			else:
				draw_line(nodes[i].position - rect_position, nodes[i-1].position - rect_position, line_color, 4)

func set_next_node():
	current_node_index+=1;
	if (current_node_index >= nodes.size()):
		current_node_index = 0;
	current_node = nodes[current_node_index];


func _on_MovingPlatform_focus_entered() -> void:
	update();
