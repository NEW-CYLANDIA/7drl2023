extends Sprite

var current_collisions:int = 0;


func _on_Area2D_body_entered(_body: Node) -> void:
	current_collisions += 1;


func _on_Area2D_body_exited(_body: Node) -> void:
	current_collisions -= 1;


func _on_Area2D_area_entered(_area: Area2D) -> void:
	current_collisions += 1


func _on_Area2D_area_exited(_area: Area2D) -> void:
	current_collisions -=1;

func set_ice(ice):
	$IceBlock.visible = ice;
