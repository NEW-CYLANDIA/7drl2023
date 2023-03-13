extends Position2D
tool

export (PackedScene) var pickup_scene


func _ready():
	if not Engine.is_editor_hint():
		$AnimatedSprite.hide()

func spawn_pickup():
	var pickup = pickup_scene.instance()
	pickup.get_node("AnimatedSprite").frame = floor(rand_range(0, pickup.taste_map.size() - 1))
	return pickup