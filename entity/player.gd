extends CharacterBody2D

@onready var bleed: PackedScene = preload('res://entity/effect/memory_leak.tscn')
@onready var bleed_tiny: PackedScene = preload('res://entity/effect/memory_leak_tiny.tscn')
@onready var pew : Resource = preload('res://asset/audio/sfx_shoot.mp3')
@onready var bowomp : Resource = preload('res://asset/audio/sfx_laser.mp3')
@onready var whoosh : Resource = preload('res://asset/audio/sfx_dash.mp3')
@onready var boop : Resource = preload('res://asset/audio/sfx_miss.mp3')

@export var speed : int = 400
@export var sneak_multiplier : float = 0.5
@export var dash_speed : int = 1000
@export var max_health : int = 4
@export var max_mana : int = 20

var health = max_health
var mana = max_mana

@export var shoot_cost: int = 1
@export var heavy_cost: int = 8

var can_shoot = true
var invincible = false
var dashing = false
var can_dash = true

var controller_mode = false

func _ready():
	Signals.position_updated.emit(get_position())
	Signals.update_health.emit(health, max_health)
	Signals.update_mana.emit(mana, max_mana)
	Signals.set_player_position.connect(set_position)
	Signals.kill.connect(_kill)

func _physics_process(_delta):
	if not dashing and can_dash and Input.is_action_just_pressed('dash'):
		dashing = true
		$dash_timer.start()
		velocity = Vector2(0, -1).rotated(get_rotation()) * dash_speed
		
		if Input.is_action_pressed('sneak'):
			velocity *= sneak_multiplier
		
		set_invincible(true)
		$mana_regeneration.set_paused(true)
		$audio_player.set_stream(whoosh)
		$audio_player.play()
	
	if dashing:
		move_and_slide()
		
		var bleed_instance = bleed_tiny.instantiate()
		var bleed_pos = get_position() + Vector2(0, 32).rotated(get_rotation())
		bleed_instance.set_position(bleed_pos)
		Signals.spawn.emit(bleed_instance)
		bleed_instance.restart()
	else:
		velocity = Vector2.ZERO
		if Input.is_action_pressed('move_right'):
			velocity.x += 1 
		if Input.is_action_pressed('move_left'):
			velocity.x -= 1   
		if Input.is_action_pressed('move_down'):
			velocity.y += 1
		if Input.is_action_pressed('move_up'):
			velocity.y -= 1
		velocity = velocity.normalized() * speed
		
		if Input.is_action_pressed('sneak'):
			velocity *= sneak_multiplier
		
		move_and_slide()
		Signals.position_updated.emit(get_position())
		
		if controller_mode:
			var controller_direction = Input.get_vector('look_left', 'look_right', 'look_down', 'look_up')
			
			if not controller_direction.is_zero_approx():
				var angle = controller_direction.angle_to(Vector2.DOWN)
				set_rotation(angle)
		else:
			var direction = get_global_transform().origin - get_global_mouse_position()
			var angle = direction.angle() - deg_to_rad(90)
			set_rotation(angle)
		
		
		if can_shoot:
			if Input.is_action_just_pressed('heavy'):
				if mana >= heavy_cost:
					$audio_player.set_stream(bowomp)
					$audio_player.play()
					Signals.heavy.emit()
					$shoot_cooldown.set_wait_time(0.2)
					$shoot_cooldown.start()
					can_shoot = false
					consume_mana(heavy_cost)
					Signals.update_mana.emit(mana, max_mana)
				else:
					Signals.mp_broke.emit()
					$audio_player.set_stream(boop)
					$audio_player.play()
			elif Input.is_action_pressed('shoot'):
				if mana >= shoot_cost:
					for child in $turrets.get_children():
						$audio_player.set_stream(pew)
						$audio_player.play()
						var bullet_instance = BulletRegistry.REGISTRY[BulletRegistry.BULLET_TYPE.BULLET].instantiate()
						bullet_instance.set_global_transform(child.get_global_transform())
						Signals.spawn.emit(bullet_instance)
						$shoot_cooldown.set_wait_time(0.1)
						$shoot_cooldown.start()
						can_shoot = false
						consume_mana(shoot_cost)
						Signals.update_mana.emit(mana, max_mana)
				else:
					Signals.mp_broke.emit()

func hurt(amount):
	if not invincible:
		health -= amount
		Signals.update_health.emit(health, max_health)

		var bleed_instance = bleed.instantiate()
		bleed_instance.set_global_transform(get_global_transform())
		Signals.spawn.emit(bleed_instance)
		bleed_instance.restart()

		if health == 0:
			queue_free()
			Signals.death.emit()
		else:
			Signals.hurt.emit()
			$hurt_cooldown.start()
			set_invincible(true)

func _on_shoot_cooldown_timeout():
	can_shoot = true

func _on_hurt_cooldown_timeout():
	set_invincible(false)

func consume_mana(amount):
	if amount <= mana:
		mana -= amount
		$mana_regeneration.start()

func _on_mana_regeneration_timeout():
	if mana == max_mana:
		$mana_regeneration.stop()
	else:
		mana = mana + 1
		Signals.update_mana.emit(mana, max_mana)

func _on_dash_timer_timeout():
	dashing = false
	set_invincible(false)
	$dash_cooldown.start()
	$mana_regeneration.set_paused(false)

func _on_dash_cooldown_timeout():
	can_dash = true

func set_invincible(flag):
	invincible = flag
	set_collision_layer_value(1, not flag)
	set_collision_layer_value(3, flag)
	set_collision_mask_value(1, not flag)
	set_collision_mask_value(3, flag)
	
	if flag:
		$polygon.set_color(Color('000000'))
	else:
		$polygon.set_color(Color('FFFFFF'))

func _input(event):
	if event is InputEventKey:
		controller_mode = false
	elif event is InputEventJoypadButton:
		controller_mode = true
	elif event is InputEventMouse:
		controller_mode = false

func _kill():
	Signals.update_health.emit(0, max_health)
	Signals.death.emit()
	queue_free()
