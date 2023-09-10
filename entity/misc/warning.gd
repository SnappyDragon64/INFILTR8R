extends Node2D

func _ready():
	Signals.mp_broke.connect(_oof)

func _process(_delta):
	set_rotation(-get_parent().get_rotation())

func _oof():
	$warning_label.set_visible(true)
	$timer.start()

func _on_timer_timeout():
	$warning_label.set_visible(false)
