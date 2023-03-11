extends Node2D

var mood:float = 0.99999;
var anims = [
	"Sad3",
	"Sad2",
	"Sad1",
	"Neutral",
	"Happy1",
	"Happy2",
	"Happy3"
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_mood();
	pass # Replace with function body.

func add_mood(mood_add):
	mood += mood_add
	if (mood < 0):
		mood = 0;
	if (mood >= 1):
		mood = 0.999;
	play_mood();
func play_mood():
	var mood_anim = floor(mood * (anims.size()));
	$Bod/Face.play(anims[mood_anim]);
	
	# this is a very basic map_range call that probably isn't needed
	# but i'm keeping it here to make adjustment easier
	scale = Vector2.ONE * MathUtil.map_range(mood_anim, 0, anims.size(), 0.75, 1.1);
