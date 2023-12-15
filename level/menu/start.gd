extends Node2D

func _ready():
	Signals.event.connect(_handle_event)
	if SaveData.check('5'):
		$title.set_text('[INFILTR8D]')
		$title.add_theme_color_override('font_color', Color('00ff00'))

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/game/map.tscn'), 0)
	elif id == 2:
		Signals.change_level.emit(load('res://level/menu/help.tscn'), 0)
