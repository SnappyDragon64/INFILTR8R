extends Camera2D

var x_min = 0
var x_max = 0
var y_max = 0
var y_min = 0

var tracking = Vector2(0, 0)
var tracking_flag = false

func _ready():
	Signals.lock_camera.connect(_lock_camera)
	Signals.position_updated.connect(_on_update_position)

func _lock_camera(start, end):
	x_min = min(start.x, end.x)
	y_min = min(start.y, end.y)
	x_max = max(start.x, end.x)
	y_max = max(start.y, end.y)

func _process(_delta):
	if tracking_flag:
		var x_clamped = clamp(tracking.x, x_min, x_max)
		var y_clamped = clamp(tracking.y, y_min, y_max)
		var origin_clamped = Vector2(x_clamped, y_clamped)
		var transform_clamped = Transform2D(0, origin_clamped)
		set_global_transform(transform_clamped)
		tracking_flag = false

func _on_update_position(new_position):
	tracking = new_position
	tracking_flag = true
