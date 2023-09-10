extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	var game_scene = load('res://game/game.tscn')
	var game_instance = game_scene.instantiate()
	get_tree().get_root().add_child(game_instance)
	Signals.change_level.emit(load('res://level/menu/start.tscn'), 0)
	queue_free()
