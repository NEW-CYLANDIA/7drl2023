extends Area2D

export (int) var value = 10

var taste_map = [
	Const.BITTER,
	Const.SWEET,
	Const.SOUR,
	Const.SALTY,
	Const.SAVORY,
]


func _on_Pickup_body_entered(body:Node):
	if body is Player:
		ScoreManager.current_level_score += value
		queue_free()

		# TODO - max out matching bud's mood?
