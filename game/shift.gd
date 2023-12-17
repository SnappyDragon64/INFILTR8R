extends ColorRect

var shift = 0
var MAP = {
	'shiny1': 0.1667,
	'shiny2': 0.8333,
	'shiny3': 0.3333,
	'shiny4': 0.6667,
	'shiny5': 0.5,
}

func _ready():
	shift = int(SaveData.check('theme'))
	var key = 'shiny' + str(shift)
	var val = MAP.get(key, 0)
	material.set_shader_parameter('shift', val)

func _process(_delta):
	if Input.is_action_just_pressed('shift'):
		increment_shift()
		var key = 'shiny' + str(shift)
		var val = 0
		
		while not SaveData.check(key) and shift != 0:
			increment_shift()
			key = 'shiny' + str(shift)
			val = MAP.get(key, 0)
		
		if shift != 0:
			val = MAP[key]

		material.set_shader_parameter('shift', val)
		SaveData.update('theme', shift)

func increment_shift():
	shift += 1
	shift %= 6
