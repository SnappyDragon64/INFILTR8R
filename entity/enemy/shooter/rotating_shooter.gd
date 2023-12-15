extends 'res://entity/enemy/brick.gd'

@export var pattern : Array[BulletRegistry.BULLET_TYPE] = []
@export var shoot_speed : float = 1
@export var speed : int = 200

@onready var visibility_notifier : VisibleOnScreenNotifier2D

var counter : int = 0
var direction : float = 0.0

func _ready():
	visibility_notifier = VisibleOnScreenNotifier2D.new()
	visibility_notifier.set_rect(Rect2(-1, -1, 2, 2))
	add_child(visibility_notifier)
	$shoot_timer.set_wait_time(shoot_speed)
	Signals.position_updated.connect(_set_target)

func _process(_delta):
	set_rotation(direction)

func _on_shoot_timer_timeout():
	if visibility_notifier.is_on_screen() and not pattern.is_empty():
		var bullet_id = pattern[counter]
		var bullet_preload = BulletRegistry.REGISTRY[bullet_id]
		counter = (counter + 1) % pattern.size()
		
		if is_instance_valid(bullet_preload):
			for child in $turrets.get_children():
				var bullet_instance = bullet_preload.instantiate()
				bullet_instance.set_global_transform(child.get_global_transform())
				Signals.spawn.emit(bullet_instance)

func _set_target(pos):
	direction = -(pos - get_global_transform().get_origin()).angle_to(Vector2.UP)
