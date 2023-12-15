extends 'res://entity/enemy/shooter/shooter.gd'

@export var speed = 1

func _physics_process(delta):
	var delta_rot = delta * speed
	var rot = get_rotation() + delta_rot
	if rot > TAU:
		rot = delta_rot
	set_rotation(rot)
