extends Node2D

var skin = 0
var MAP = {
	'hex0': Color(0, 1, 1),
	'hex1': Color(0.25, 0.25, 0.25),
	'hex2': Color(0.75, 0.75, 0.75),
	'hex3': Color(1, 1, 0),
	'hex4': Color(1, 0, 0),
}

func _ready():
	skin = int(SaveData.check('skin'))
	var key = 'hex' + str(skin)
	var val = MAP.get(key)
	set_modulate(val)
	SaveData.update('hex0', true)
	Signals.hurt.connect(_on_hurt)

func _on_hurt():
	for child in get_children():
		if child.is_visible():
			child.set_visible(false)
			break

func _process(_delta):
	if Input.is_action_just_pressed('skin'):
		increment_shift()
		var key = 'hex' + str(skin)
		
		while not SaveData.check(key):
			increment_shift()
			key = 'hex' + str(skin)
		
		var val = MAP.get(key)
		set_modulate(val)
		SaveData.update('skin', skin)

func increment_shift():
	skin += 1
	skin %= 5
