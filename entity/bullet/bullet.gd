extends Area2D

@export var speed: float = 800
@export var damage: int = 1
@export_enum('player', 'enemy') var will_hurt: String
@export var ignores: Array[String] = []

@onready var bleed: PackedScene = preload('res://entity/effect/memory_leak_tiny.tscn')
@onready var velocity: Vector2 = Vector2(speed, 0).rotated(rotation - deg_to_rad(90))

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_hit(object):
	if object.is_in_group(will_hurt):
		object.hurt(damage)
	
	var flag = true
	
	for group in ignores:
		if object.is_in_group(group):
			flag = false
	
	if flag:
		die()

func die():
	var bleed_instance = bleed.instantiate()
	bleed_instance.set_position(get_position())
	bleed_instance.restart()
	Signals.spawn.emit(bleed_instance)
	queue_free()
