extends Position2D

export (PackedScene) var player
export (PackedScene) var camera
export (PackedScene) var hud
export (PackedScene) var walls


func spawn_test_nodes():
	var test_walls = walls.instance()
	get_parent().add_child(test_walls)
	var player_inst = player.instance()

	player_inst.position = position
	
	get_parent().add_child(player_inst)



	get_parent().add_child(camera.instance())
