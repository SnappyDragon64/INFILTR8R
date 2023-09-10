extends Node2D

@onready var bleed: PackedScene = preload('res://entity/effect/memory_leak_small.tscn')
@export var damage: int = 4
var active = false
var update_hitbox = false
var cached_length: int

func _ready():
	Signals.heavy.connect(_heavy)

func _physics_process(_delta):
	if active:
		$raycast.force_raycast_update()
		if $raycast.is_colliding():
			var collision_point = $raycast.get_collision_point()
			var origin = $raycast.get_global_transform().get_origin()
			var distance = collision_point - origin
			var length = distance.length()
			var packed_array = PackedVector2Array()
			packed_array.push_back(Vector2(0, 0))
			packed_array.push_back(Vector2(0, length))
			cached_length = length
			$line.set_points(packed_array)
			var bleed_instance = bleed.instantiate()
			bleed_instance.set_position(collision_point)
			bleed_instance.restart()
			Signals.spawn.emit(bleed_instance)
		else:
			var packed_array = PackedVector2Array()
			packed_array.push_back(Vector2(0, 0))
			packed_array.push_back(Vector2(0, 2000))
			cached_length = 2000
			$line.set_points(packed_array)
	
	if update_hitbox:
		var half_length = cached_length * 0.5
		$hitbox.get_shape().set_size(Vector2(25, cached_length + 8))
		$hitbox.set_position(Vector2(0, -half_length))

func _heavy():
	if not active:
		active = true
		$raycast.set_enabled(true)
		$duration.start()
		$hitbox_enable.start()
		var tween = create_tween().set_parallel(true)
		tween.tween_property($line, 'width', 40, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.chain().tween_property($line, 'width', 0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_duration_timeout():
	active = false
	$raycast.set_enabled(false)
	var packed_array = PackedVector2Array()
	$line.set_points(packed_array)

func _on_hit(object):
	if object.is_in_group('enemy'):
		object.hurt(damage)

func _on_hitbox_enable_timeout():
	update_hitbox = true
	$hitbox.set_disabled(false)
	$hitbox_disable.start()

func _on_hitbox_disable_timeout():
	update_hitbox = false
	$hitbox.set_disabled(true)
