extends CharacterBody2D

@export var pattern : Array[BulletRegistry.BULLET_TYPE] = []
@export var shoot_speed : float = 1
@export var speed : int = 100

var counter : int = 0
var direction : float = 0.0

var active = false

func _ready():
	$shoot_timer.set_wait_time(shoot_speed)

func _process(_delta):
	if active:
		set_rotation(direction)
		velocity = Vector2.UP.rotated(direction) * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_shoot_timer_timeout():
	if not pattern.is_empty():
		var bullet_id = pattern[counter]
		var bullet_preload = BulletRegistry.REGISTRY[bullet_id]
		counter = (counter + 1) % pattern.size()
		
		if is_instance_valid(bullet_preload):
			for child in $turrets.get_children():
				var bullet_instance = bullet_preload.instantiate()
				bullet_instance.set_global_transform(child.get_global_transform())
				Signals.spawn.emit(bullet_instance)

func _set_target(pos):
	direction = -(pos - get_global_transform().get_origin()).angle_to(Vector2.UP)

@export var health = 4
@export var event = 0

@onready var bleed: PackedScene = preload('res://entity/effect/memory_leak.tscn')

func hurt(amount):
	health -= amount

	var bleed_instance = bleed.instantiate()
	bleed_instance.set_global_transform(get_global_transform())
	Signals.spawn.emit(bleed_instance)
	bleed_instance.restart()

	if health <= 0:
		Signals.event.emit(event)
		queue_free()

func _on_detection_range_body_entered(body):
	if body.is_in_group('player'):
		Signals.position_updated.connect(_set_target)
		active = true

func _on_detection_range_body_exited(body):
	if body.is_in_group('player'):
		Signals.position_updated.disconnect(_set_target)
		active = false
