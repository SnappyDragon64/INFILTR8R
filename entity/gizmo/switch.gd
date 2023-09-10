extends Area2D

@onready var on_sprite : Resource = preload("res://asset/sprite/entity/switch_on.png")
@onready var off_sprite : Resource = preload("res://asset/sprite/entity/switch_off.png")
@onready var disabled_sprite : Resource = preload("res://asset/sprite/entity/switch_disabled.png")
@export var event : int = 0
@export var is_disabled : bool = false
@export var unlock_event : int = 999

var on = false
var current = false
var value = 0

func _ready():
	if is_disabled:
		$sprite.set_texture(disabled_sprite)
		Signals.event.connect(_handle_event)

func _handle_event(incoming_event):
	if incoming_event == unlock_event:
		is_disabled = false
		$sprite.set_texture(off_sprite)

func _process(_delta):
	if not is_disabled:
		if current and Input.is_action_pressed('interact'):
			value = min(value + 1, 80)
		elif not on:
			value = max(value - 1, 0)
		
		$progress.set_value(value)
		
		if value == 80:
			on = true
			$sprite.set_texture(on_sprite)
			Signals.event.emit(event)

func _on_body_entered(body):
	if body.is_in_group('player'):
		current = true

func _on_body_exited(body):
	if body.is_in_group('player'):
		current = false
