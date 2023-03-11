extends Node2D

class LevelNode:
	#array of ExitDirs enums
	var exits:Array = [];
	var pos:Vector2 = Vector2();

class PathLine:
	var start:Vector2;
	var end:Vector2;
	func _init(_start, _end) -> void:
		start = _start;
		end = _end;


export var level_length:int = 5;	
	
# which folders to exclude from our level chunk search
export(Array, String) var exclude_folders:Array

export(PackedScene) var line_col_check;

export var enabled:bool = true;
# an array of vectors that define a line
# this line will be the path through the level,
# and will instruct us which tiles to place where
var happy_path:Array = [];

# an array of the actual built level chunks
# that we will place to build the level
var level_chunks:Array = [];

var collision_nodes = [];
var dirs:Array = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]
var last_dir; # the last direction the happy path went
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_chunk_array();
	#we're gonna be placing tiles via their center, 
	#so this ensures we're lining up the first tile with the player
	position = LevelUtil.TILE_SIZE/2;
	if (enabled):
		build_level();
	
func build_level():
	build_happy_path();
	place_chunks();
	

func build_chunk_array():
	var dir_path = "res://src/LevelChunks/"
	var dir := Directory.new()
	dir.open(dir_path)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if dir.current_is_dir() && file != "." && file != "..":
			if (exclude_folders.find(file) == -1):
				var inner_dir := Directory.new();
				inner_dir.open(dir_path + file)
				inner_dir.list_dir_begin();
				var inner_file = inner_dir.get_next();
				while inner_file != "":
					if (inner_file.get_extension() == "tscn"):
						var path = dir_path + file + "/" + inner_file
						level_chunks.append(load(path));
					inner_file = inner_dir.get_next();
				inner_dir.list_dir_end();
		file = dir.get_next();

## this will determine the main path of our level
func build_happy_path():
	randomize();
	var current_point = Vector2.ZERO;
	for i in range (0, level_length):
		var dirs_to_consider = [] + dirs; # cloning dirs
		var dir_index = round(rand_range(0, dirs_to_consider.size()-1));
		var dir:Vector2 = dirs_to_consider[dir_index] * LevelUtil.TILE_SIZE;
		dirs_to_consider.remove(dir_index);
		$RayCast.position = current_point;
		$RayCast.cast_to = dir
		$RayCast.force_raycast_update();
		while (($RayCast.is_colliding() and dirs_to_consider.size() > 0)):
			dir_index = floor(rand_range(0, dirs_to_consider.size()-1));
			dir = dirs_to_consider[dir_index] * LevelUtil.TILE_SIZE;
			dirs_to_consider.remove(dir_index);
			$RayCast.cast_to = dir;
			$RayCast.force_raycast_update();
		if ($RayCast.is_colliding()):
			print("uh oh, happy path can't be built");
			return;
		else:
			happy_path.append(PathLine.new(current_point, current_point + dir))
			var collision_node:Node2D = line_col_check.instance();
			collision_node.position = current_point;
			if (last_dir):
				collision_node.exits.append(last_dir.normalized());
			collision_node.exits.append(dir.normalized());
			last_dir = dir * -1;
			add_child(collision_node);
			collision_nodes.append(collision_node);
			current_point += dir;

	var last_node = line_col_check.instance();
	last_node.position = happy_path[happy_path.size()-1].end;
	last_node.exits.append(last_dir.normalized());
	add_child(last_node)
	collision_nodes.append(last_node)

func _draw() -> void:
	for l in happy_path:
		draw_line(l.start, l.end, Color.blue, 5.0);

func place_chunks():
	randomize();
	level_chunks.shuffle();
	for node in collision_nodes:
		for chunk in level_chunks:
			var chunk_instance:Node2D = chunk.instance();
			if (arrays_are_similar(chunk_instance.exits, node.exits)):
				add_child(chunk_instance);
				chunk_instance.position = ((node.position - LevelUtil.TILE_SIZE/2) as Vector2).round()
			else:
				chunk_instance.queue_free();
				
				
# do they contain the same elements 
#(i think this only works with values, not refs)
func arrays_are_similar(array1, array2):
	if array1.size() != array2.size():
		return false
	
	var sortedArray1:Array = array1.duplicate()
	sortedArray1.sort()
	
	var sortedArray2:Array = array2.duplicate()
	sortedArray2.sort();
	
	for i in range(array1.size()):
		if sortedArray1[i] != sortedArray2[i]:
				print("nope");
				return false
	print("yep");
	return true

	
func modify_platforms(chunk):
	pass;
	
