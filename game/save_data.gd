extends Node

@onready var save_data := {
	'1': false,
	'2': false,
	'3': false,
	'4': false,
	'5': false,
	'shiny1': false,
	'shiny2': false,
	'shiny3': false,
	'shiny4': false,
	'shiny5': false,
	'hex0': true,
	'hex1': false,
	'hex2': false,
	'hex3': false,
	'hex4': false,
	'theme': 0,
	'skin': 0
}

func _ready():
	_load()
	
	if typeof(check('theme')) == TYPE_BOOL:
		update('theme', 0)
	if typeof(check('skin')) == TYPE_BOOL:
		update('skin', 0)

func update(key, value):
	save_data[str(key)] = value
	if value:
		var player = get_tree().get_first_node_in_group('player')
		if player.health == player.max_health:
			save_data['shiny' + str(key)] = true
	
	_save()

func check(key):
	return save_data.get(str(key), false)

func _save():
	var save = FileAccess.open('user://hello.there', FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	save.store_line(json_string)
	save.close()

func _load():
	if not FileAccess.file_exists('user://hello.there'):
		_save()
	else:
		var save = FileAccess.open('user://hello.there', FileAccess.READ)
		var json_string = save.get_line()
		var parsed_json = JSON.parse_string(json_string)
		save_data = parsed_json
		save.close()
