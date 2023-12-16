extends StaticBody2D

@onready var on_sprite : Resource = preload("res://asset/sprite/entity/power_brick_on.png")
@onready var off_sprite : Resource = preload("res://asset/sprite/entity/power_brick_off.png")
@export var event : int = 0
@export var capacity : int = 8

var on = false
var value = 0

func _ready():
	$progress.set_max(capacity)

func hurt(damage):
	if not on:
		value += damage
		$progress.set_value(value)
		
		if value >= capacity:
			on = true
			$sprite.set_texture(on_sprite)
			Signals.event.emit(event)

func reset():
	value = 0
	$progress.set_value(0)
	on = false
	$sprite.set_texture(off_sprite)
