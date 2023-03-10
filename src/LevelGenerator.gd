extends Node2D

class LevelTile:
	#array of ExitDirs enums
	var exits:Array = [];
	# this is in grid space, not world space
	var grid_pos:Vector2 = Vector2();

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
# an array of tiles (tiles are just lists of exits)
# when we're done generating these, we're gonna go through
# and search for level chunks that match
var tiles_needed:Array = [];

# an array of vectors that define a line
# this line will be the path through the level,
# and will instruct us which tiles to place where
var happy_path:Array = [];

# an array of the actual built level chunks
# that we will place to build the level
var level_chunks:Array = [];

var collision_nodes = [];
var dirs:Array = [
	{"value": Vector2.LEFT, "weight": 0.24},
	{"value": Vector2.RIGHT, "weight": 0.29},
	{"value": Vector2.UP, "weight": 0.24},
	{"value": Vector2.DOWN, "weight": 0.24},
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_chunk_array();
	# we're gonna be placing tiles via their center, 
	#so this ensures we're lining up the first tile with the player
	position = LevelUtil.TILE_SIZE/2;
	build_level();
	
func build_level():
	
	build_happy_path();
	build_tiles_needed();
	place_chunks();
	
	
# search thru our LevelChunk array and pull out whatever we can use
func build_chunk_array():
	var dir_path = "res://src/LevelChunks/"
	var dir := Directory.new()
	dir.open(dir_path)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if dir.current_is_dir():
			if (exclude_folders.find(file) == -1):
				var inner_dir := Directory.new();
				inner_dir.open(dir_path + file)
				inner_dir.list_dir_begin();
				var inner_file = inner_dir.get_next();
				while inner_file != "":
					if (inner_file.get_extension() == "tscn"):
						level_chunks.append(dir_path + file + "/" + inner_file)
					inner_file = inner_dir.get_next();
				inner_dir.list_dir_end();
		file = dir.get_next();

## this will determine the main path of our level
func build_happy_path():
	var current_point = Vector2.ZERO;
	for i in range (0, level_length):
		var dirs_to_consider = [] + dirs; # cloning dirs
		var dir = LevelUtil.weighted_random_pick(dirs_to_consider);
		dirs_to_consider.remove(dirs_to_consider.find(dir));
		var scaled_dir = dir * LevelUtil.TILE_SIZE;
		$RayCast.position = current_point;
		$RayCast.cast_to = scaled_dir;
		while ($RayCast.is_colliding() and dirs_to_consider.size() > 0):
			dir = LevelUtil.weighted_random_pick(dirs_to_consider) * LevelUtil.TILE_SIZE;
			dirs_to_consider.remove(dirs_to_consider.find(dir));
			$RayCast.cast_to = dir * LevelUtil.TILE_SIZE;
		if ($RayCast.is_colliding()):
			print("uh oh, happy path can't be built");
			return;
		else:
			happy_path.append(PathLine.new(current_point, current_point + dir * LevelUtil.TILE_SIZE))
			current_point += dir * LevelUtil.TILE_SIZE;
			var collision_node:Node2D = line_col_check.instance();
			collision_node.position = current_point;
			add_child(collision_node);
			collision_nodes.append(collision_node);
			
			
			
func _draw() -> void:
	for line in happy_path:
		draw_line(line.start, line.end, Color.blue, 6.0);
		
		
func build_tiles_needed():
	pass;

func place_chunks():
	pass;
	
func modify_platforms(chunk):
	pass;
