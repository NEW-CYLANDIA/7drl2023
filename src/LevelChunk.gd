extends Node2D


export(Array, Vector2) var exits;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().name != "LevelGenerator":
		$PlayerSpawn.spawn_test_nodes()
	
	if (has_node("PickupSp`awns")):
		var pickupSpawners = get_node("PickupSpawns").get_children()
		randomize()
		pickupSpawners.shuffle()
		print(pickupSpawners)

		var pickup = pickupSpawners[0].pickup_scene.instance()
		pickup.get_node("AnimatedSprite").frame = floor(rand_range(0, pickup.taste_map.size() - 1))
		pickup.position = pickupSpawners[0].position
		add_child(pickup)
