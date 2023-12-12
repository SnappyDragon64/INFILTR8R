extends Node2D

var CORRECT = [5, 8, 7, 6]
var unlock_counter_1 = 0
var unlock_counter_2 = 0
var puzzle_sequence = []

func _ready():
	Signals.event.connect(_handle_event)

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/game/map.tscn'), 1)
	elif id == 2:
		unlock_counter_1 += 1
		
		if unlock_counter_1 == 4:
			Signals.event.emit(3)
	elif id >= 5 and id <= 8:
		puzzle_sequence.append(id)
		check_puzzle()
	elif id == 21:
		SaveData.update(4, true)
		Signals.change_level.emit(load('res://level/game/map.tscn'), 1)
	elif id == 22:
		unlock_counter_2 += 1
		
		if unlock_counter_2 == 4:
			Signals.event.emit(23)

func check_puzzle():
	if len(puzzle_sequence) == 4:
		var flag = true
		
		for i in range(0, 4):
			if puzzle_sequence[i] != CORRECT[i]:
				flag = false
				break
		
		if flag:
			Signals.event.emit(9)
		else:
			$power_brick5.reset()
			$power_brick6.reset()
			$power_brick7.reset()
			$power_brick8.reset()
			puzzle_sequence.clear()
