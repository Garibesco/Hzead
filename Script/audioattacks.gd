extends AudioStreamPlayer2D

@export var streams : Array[AudioStream] 
var music_key : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_track():
	var rng = RandomNumberGenerator.new()
	var id = rng.randi_range(0, 11)
	if id in music_key:
		stream = streams[id]
	else:
		stream = streams[music_key[0]]
	play()
	
func play_random():
	var rng = RandomNumberGenerator.new()
	var id = rng.randi_range(0, streams.size()-1)
	stream = streams[id]
	play()

func set_key(key:Array):
	music_key = key
