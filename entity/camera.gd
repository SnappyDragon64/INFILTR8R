extends Camera2D

@export var peek_speed = 4

var x_min = 0
var x_max = 0
var y_max = 0
var y_min = 0

var tracking = Vector2(0, 0)
var tracking_flag = false

func _ready():
	Signals.lock_camera.connect(_lock_camera)
	Signals.position_updated.connect(_on_update_position)
	Signals.set_zoom.connect(_set_zoom)

func _lock_camera(start, end):
	x_min = min(start.x, end.x)
	y_min = min(start.y, end.y)
	x_max = max(start.x, end.x)
	y_max = max(start.y, end.y)

func _set_zoom(zoom_vector):
	set_zoom(zoom_vector)

func _process(_delta):
	if Input.is_action_pressed('peek'):
		var movement = Vector2()
		var is_sneaking = Input.is_action_pressed('sneak')
		var adjusted_peek_speed = peek_speed * 0.5 if is_sneaking else peek_speed
		
		if Input.is_action_pressed('move_right'):
			movement.x += 1
		if Input.is_action_pressed('move_left'):
			movement.x -= 1
		if Input.is_action_pressed('move_down'):
			movement.y += 1
		if Input.is_action_pressed('move_up'):
			movement.y -= 1
		
		movement = movement.normalized() * adjusted_peek_speed
		position += movement
	elif tracking_flag:
		var origin_clamped = get_adjusted_tracking_pos()
		var transform_clamped = Transform2D(0, origin_clamped)
		set_global_transform(transform_clamped)
		tracking_flag = false

func _on_update_position(new_position):
	tracking = new_position
	tracking_flag = true

func get_adjusted_tracking_pos():
	var x_clamped = clamp(tracking.x, x_min, x_max)
	var y_clamped = clamp(tracking.y, y_min, y_max)
	var origin_clamped = Vector2(x_clamped, y_clamped)
	return origin_clamped
