extends StaticBody2D

@export var event : int = 0

func _ready():
	Signals.event.connect(_handle_event)

func _handle_event(incoming_event):
	if incoming_event == event:
		queue_free()
