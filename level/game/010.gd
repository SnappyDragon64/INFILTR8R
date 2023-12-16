extends Node2D

func _ready():
	Signals.event.connect(_handle_event)

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/game/map.tscn'), 1)
	elif id == 2:
		$switch2.set_disabled(true)
	elif id == 3:
		$switch.set_disabled(true)
	elif id == 4:
		$switch5.set_disabled(true)
	elif id == 5:
		$switch4.set_disabled(true)
	elif id == 6:
		SaveData.update(3, true)
		Signals.change_level.emit(load('res://level/game/map.tscn'), 1)

func _on_hex_area_entered(area):
	SaveData.update('hex3', true)
