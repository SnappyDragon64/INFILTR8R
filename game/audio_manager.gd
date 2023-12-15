extends AudioStreamPlayer

var TRACKS = [
	preload('res://asset/audio/mus_game.mp3'),
	preload('res://asset/audio/mus_boss.mp3'),
	preload('res://asset/audio/mus_static.mp3')
]

func _ready():
	Signals.change_track.connect(_change_track)

func _change_track(id):
	if id == 2:
		set_stream(TRACKS[id])
		play()
	else:
		stop()
