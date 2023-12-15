extends 'res://entity/enemy/brick.gd'

@export var speed = 1
var rot = 0.0
var spin_dir = 1
var spin_factor = 1
var move_range = 0
var move_factor = 0
var move_dir = 1

var spawn_anim_preload = preload('res://entity/effect/spawn_anim.tscn')
var current_wave = 0
var phase = 1

var armor_down = preload('res://asset/audio/sfx_armor_down.mp3')
var new_wave = preload('res://asset/audio/sfx_new_wave.mp3')

var PHASE_1_WAVES = [
	preload('res://entity/enemy/boss/wave/1_1.tscn'),
	preload('res://entity/enemy/boss/wave/1_2.tscn'),
	preload('res://entity/enemy/boss/wave/1_3.tscn'),
	preload('res://entity/enemy/boss/wave/1_4.tscn'),
]
var PHASE_2_WAVES = [
	preload('res://entity/enemy/boss/wave/2_1.tscn'),
	preload('res://entity/enemy/boss/wave/2_2.tscn'),
	preload('res://entity/enemy/boss/wave/2_3.tscn'),
	preload('res://entity/enemy/boss/wave/2_4.tscn'),
	preload('res://entity/enemy/boss/wave/2_5.tscn'),
]
var PHASE_3_WAVES = [
	preload('res://entity/enemy/boss/wave/3_1.tscn'),
	preload('res://entity/enemy/boss/wave/3_2.tscn'),
	preload('res://entity/enemy/boss/wave/3_3.tscn'),
	preload('res://entity/enemy/boss/wave/3_4.tscn'),
	preload('res://entity/enemy/boss/wave/3_5.tscn'),
	preload('res://entity/enemy/boss/wave/3_6.tscn'),
]
var PHASE_4_WAVES = []

var PHASE_WAVES = {
	1: PHASE_1_WAVES,
	2: PHASE_2_WAVES,
	3: PHASE_3_WAVES,
	4: PHASE_4_WAVES,
}

func _ready():
	play_audio(new_wave)
	Signals.event.connect(_handle_event)
	PHASE_1_WAVES.shuffle()
	PHASE_2_WAVES.shuffle()
	PHASE_3_WAVES.shuffle()
	PHASE_4_WAVES.append_array(PHASE_3_WAVES)

func _handle_event(id):
	if id == 0:
		spawn_bleed_effect()
	
		$check_timer.start()
		await $check_timer.timeout
		var count = 0
		for wave in $carousel.get_children():
			for holder in wave.get_children():
				count += len(holder.get_children())
		
		if count == 0:
			$wave_timer.start()

func _physics_process(delta):
	var delta_rot = delta * speed * spin_dir * spin_factor
	rot += delta_rot
	if rot > TAU:
		rot = delta_rot
	elif rot < 0:
		rot = TAU - delta_rot
	
	if phase > 1:
		var abs_x = abs(position.x)
		var adjusted_x = move_range if abs_x > move_range else abs_x
		var speed_adjustment = 1 + sin(adjusted_x/move_range * PI/2)
		var movement_delta = move_dir * abs(delta_rot) * move_factor * speed_adjustment
		position.x += movement_delta
		Signals.boss_position_updated.emit(position)
	
	if position.x > move_range:
		move_dir = -1
	elif position.x < -move_range:
		move_dir = 1
	
	$model/base.set_rotation(rot)
	$hitbox.set_rotation(rot)
	$model/eye.set_rotation(-2*rot)
	$model/pupil.set_rotation(2*rot)
	$carousel.set_rotation(-rot)

	if phase < 4:
		$spikes.set_rotation(rot)

func shed_armor():
	play_audio(armor_down)
	$spikes.queue_free()
	add_to_group('enemy')
	set_collision_layer_value(2, false)
	var tween = get_tree().create_tween()
	tween.tween_property($model/base, "color", Color(0.5, 0, 0), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)

func _on_wave_timer_timeout():
	spawn_bleed_effect()
	play_audio(new_wave)
	var wave_to_spawn = get_wave()
	var wave = wave_to_spawn.instantiate()
	ride_the_carousel(wave)

func get_wave():
	current_wave += 1
	spin_dir *= -1
	update_phase()
	var waves = PHASE_WAVES[phase]
	
	if phase < 4:
		return waves.pop_front()
	else:
		waves.shuffle()
		return waves[0]

func update_phase():
	if current_wave == 3:
		phase = 2
		spin_factor = 1.25
		move_factor = 150
		move_range = 640
		var tween = get_tree().create_tween()
		tween.tween_property($model/eye, "color", Color(0.75, 0.75, 0.75), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($model/pupil, "color", Color(1, 1, 1), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	elif current_wave == 7:
		phase = 3
		spin_factor = 1.5
		move_factor = 200
		move_range = 1024
		var tween = get_tree().create_tween()
		tween.tween_property($model/eye, "color", Color(0.5, 0.5, 0), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($model/pupil, "color", Color(1, 1, 0), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	elif current_wave == 12:
		phase = 4
		spin_factor = 2
		move_factor = 100
		move_range = 320
		shed_armor()
		var tween = get_tree().create_tween()
		tween.tween_property($model/eye, "color", Color(1, 0, 0), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($model/pupil, "color", Color(0.5, 0, 0), 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)

func ride_the_carousel(wave):
	for child in $carousel.get_children():
		child.queue_free()
	
	$carousel.add_child(wave)

func spawn_bleed_effect():
	var bleed_instance = bleed.instantiate()
	bleed_instance.set_global_transform(get_global_transform())
	Signals.spawn.emit(bleed_instance)
	bleed_instance.restart()

func play_audio(sound):
	$audio_player.set_stream(sound)
	$audio_player.play()
