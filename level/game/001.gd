extends Node2D

func _ready():
	Signals.event.connect(_handle_event)

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/game/map.tscn'), 0)
	elif id == 4:
		SaveData.update(2, true)
		Signals.change_level.emit(load('res://level/game/map.tscn'), 0)
