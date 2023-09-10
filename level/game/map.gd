extends Node2D

func _ready():
	Signals.event.connect(_handle_event)
	_unlock()

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/menu/start.tscn'), 0)
	elif id == 2:
		Signals.change_level.emit(load('res://level/game/0000.tscn'), 0)
	elif id == 3:
		Signals.change_level.emit(load('res://level/game/0001.tscn'), 0)
	elif id == 4:
		Signals.change_level.emit(load('res://level/game/0010.tscn'), 0)
	elif id == 5:
		Signals.change_level.emit(load('res://level/game/0011.tscn'), 0)
	elif id == 6:
		Signals.change_level.emit(load('res://level/game/0100.tscn'), 0)
	elif id == 7:
		Signals.change_level.emit(load('res://level/game/0101.tscn'), 0)
	elif id == 8:
		Signals.change_level.emit(load('res://level/game/0110.tscn'), 0)
	elif id == 9:
		Signals.change_level.emit(load('res://level/game/0111.tscn'), 0)
	elif id == 10:
		Signals.change_level.emit(load('res://level/game/1111.tscn'), 0)

func _unlock():
	for i in range(1, 9, 1):
		if SaveData.check(i):
			var unlock_event = i + 10
			Signals.event.emit(unlock_event)
