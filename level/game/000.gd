extends Node2D

func _ready():
	Signals.event.connect(_handle_event)

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/game/map.tscn'), 0)
	elif id == 3:
		SaveData.update(1, true)
		Signals.change_level.emit(load('res://level/game/map.tscn'), 0)

func _on_hex_area_entered(area):
	SaveData.update('hex1', true)
