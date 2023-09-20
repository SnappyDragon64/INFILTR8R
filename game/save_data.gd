extends Node

@onready var save_data = {
	'1': false,
	'2': false,
	'3': false,
	'4': false
}

func _ready():
	_load()

func update(key, value):
	save_data[str(key)] = value
	_save()

func check(key):
	return save_data[str(key)]

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
