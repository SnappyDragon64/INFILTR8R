extends Sprite2D

func _ready():
	Signals.controller_mode.connect(_on_controller_mode)

func _process(_delta):
	position = get_global_mouse_position()

func _on_controller_mode(flag):
	set_visible(not flag)
