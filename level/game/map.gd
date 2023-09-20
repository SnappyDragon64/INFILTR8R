extends Node2D

func _ready():
	Signals.event.connect(_handle_event)
	_unlock()

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/menu/start.tscn'), 0)
	elif id == 2:
		Signals.change_level.emit(load('res://level/game/000.tscn'), 0)
	elif id == 3:
		Signals.change_level.emit(load('res://level/game/001.tscn'), 0)
	elif id == 4:
		Signals.change_level.emit(load('res://level/game/010.tscn'), 0)
	elif id == 5:
		Signals.change_level.emit(load('res://level/game/011.tscn'), 0)
	elif id == 6:
		Signals.change_level.emit(load('res://level/game/100.tscn'), 0)

func _unlock():
	for i in range(1, 5, 1):
		if SaveData.check(i):
			var unlock_event = i + 10
			Signals.event.emit(unlock_event)
