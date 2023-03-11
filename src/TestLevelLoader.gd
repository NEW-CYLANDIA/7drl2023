extends Node2D
tool


# export(String, FILE) var level_to_load;
export var enabled = false;

var level_path : String = "res://src/LevelChunks/Testing/"

var level_scenes : Array
var level_count : int
var level_to_load : String setget on_level_selection_changed


func _get_property_list() -> Array:
	return [
		{
			name = "level_to_load",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = PoolStringArray(level_scenes).join(","),
		},
	]


func on_level_selection_changed(value):
	level_to_load = value
	property_list_changed_notify()


func _ready() -> void:
	if not Engine.is_editor_hint():
		var level_instance = load(level_path + level_to_load).instance();
		add_child(level_instance);


func _process(_delta):
	if Engine.is_editor_hint():
		level_scenes = list_files_in_directory(level_path)

		var new_level_count = level_scenes.size()

		if new_level_count != level_count:
			property_list_changed_notify()
			level_count = new_level_count


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
