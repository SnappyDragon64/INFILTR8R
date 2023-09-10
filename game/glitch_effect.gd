extends Control

func _ready():
	Signals.hurt.connect(_glitch)
	Signals.death.connect(_glitch_no_timer)
	Signals.reload_level.connect(_hide)

func _glitch():
	$glitch.set_visible(true)
	$timer.start()

func _glitch_no_timer():
	$glitch.set_visible(true)
	$timer.stop()

func _hide():
	$glitch.set_visible(false)
