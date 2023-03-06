extends Node2D

var mood:int = 7;
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
	if (mood > anims.size()):
		mood = anims.size()
	if (mood < 0):
		mood = 0;
	play_mood();
func play_mood():
	var ceil_mood = ceil(mood);
	$Bod/Face.play(anims[ceil(mood)-1]);
