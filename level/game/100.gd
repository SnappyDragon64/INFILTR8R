extends Node2D

var power_brick_preload = preload('res://entity/gizmo/power_brick.tscn')
var boss_preload = preload('res://entity/enemy/boss/magna.tscn')
var spawn_anim_preload = preload('res://entity/effect/spawn_anim.tscn')
var explosion_preload = preload('res://entity/effect/explosion.tscn')

var boss_position = Vector2()

func _ready():
	Signals.change_track.emit(1)
	Signals.event.connect(_handle_event)
	Signals.boss_position_updated.connect(_on_boss_position_updated)

func _handle_event(id):
	if id == 1:
		Signals.change_level.emit(load('res://level/game/map.tscn'), 0)
	elif id == 2:
		on_boss_death()
	elif id == 3:
		game_finish()

func _on_boss_position_updated(new_position):
	boss_position = new_position

func _on_trigger_area_area_entered(_area):
	$trigger_area.queue_free()
	Signals.set_zoom.emit(Vector2(0.5, 0.5))
	var power_brick = power_brick_preload.instantiate()
	power_brick.set_position($block_spawn.get_position())
	power_brick.set_visible(false)
	Signals.spawn.emit(power_brick)
	Signals.update_spawnpoint.emit(1)
	$boss_spawn_timer.start()

func _on_boss_spawn_timer_timeout():
	var boss = boss_preload.instantiate()
	boss.set_position($boss_spawn.get_position())
	var spawn_anim = spawn_anim_preload.instantiate()
	spawn_anim.set_scale(Vector2(5, 5))
	boss.add_child(spawn_anim)
	Signals.spawn.emit(boss)

func on_boss_death():
	var explosion = explosion_preload.instantiate()
	explosion.set_position(boss_position)
	$audio_player.set_position(boss_position)
	$audio_player.play()
	Signals.spawn.emit(explosion)
	Signals.god_mode.emit(1)
	$post_boss_death_timer.start()

func _on_post_boss_death_timer_timeout():
	for slug in get_tree().get_nodes_in_group('enemy_bullet'):
		slug.queue_free()
	
	$switch.set_position(boss_position)
	$switch.event = 3

func game_finish():
	SaveData.update(5, true)
	Signals.change_level.emit(load('res://level/menu/start.tscn'), 0)
