extends Area2D

export (int) var value = 0.1

var taste_map = [
	Const.BITTER,
	Const.SWEET,
	Const.SOUR,
	Const.SALTY,
	Const.SAVORY,
]


func _on_Pickup_body_entered(body:Node):
	if body is Player:
		body.add_flavor(taste_map[$AnimatedSprite.frame], value)
		queue_free()

		# TODO - max out matching bud's mood?
