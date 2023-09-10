extends StaticBody2D

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
