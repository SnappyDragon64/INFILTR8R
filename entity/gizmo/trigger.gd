extends Area2D

@export var event : int = 0

func _on_body_entered(_body):
	Signals.event.emit(event)
