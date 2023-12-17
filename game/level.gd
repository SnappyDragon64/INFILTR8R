extends Node2D

@export var hud_height = 64
@onready var player = preload('res://entity/player.tscn')
@onready var camera = preload('res://entity/camera.tscn')

var current_level = null
var current_spawnpoint = null

func _ready():
	Signals.change_level.connect(_change_level)
	Signals.update_spawnpoint.connect(_update_spawnpoint)
	Signals.spawn.connect(_spawn)
	Signals.reload_level.connect(_reload_level)

func _change_level(scene, spawnpoint):
	if scene != null:
		Signals.change_track.emit(0)
		for child in get_children():
			child.queue_free()
		
		var level_instance = scene.instantiate()
		_spawn(level_instance)
		current_level = scene
		current_spawnpoint = spawnpoint
		
		var player_instance = player.instantiate()
		var camera_instance = camera.instantiate()
		
		var spawnpoints = level_instance.get_node_or_null('spawnpoints')
		if spawnpoints != null and spawnpoint >= 0 and spawnpoint < spawnpoints.get_child_count():
			var spawnpoint_node = spawnpoints.get_child(spawnpoint)
			var pos = spawnpoint_node.get_global_transform().get_origin()
			player_instance.set_position(pos)
			
			var camera_spawnpoint = spawnpoint_node.get_node_or_null('camera')
			if camera_spawnpoint != null:
				camera_instance.set_position(camera_spawnpoint.get_global_transform().get_origin())
			else:
				camera_instance.set_position(pos)
		
		_spawn(player_instance)
		_spawn(camera_instance)

func _spawn(object):
	add_child(object)

func _reload_level():
	_change_level(current_level, current_spawnpoint)

func _update_spawnpoint(spawnpoint):
	current_spawnpoint = spawnpoint
