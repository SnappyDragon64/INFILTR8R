extends 'res://entity/enemy/shooter/shooter.gd'

@export var speed = 1

func _physics_process(delta):
	rotation += delta * speed
