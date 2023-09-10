extends CPUParticles2D

func _on_lifetime_timeout():
	queue_free()
