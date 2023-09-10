extends Area2D

func _on_area_entered(area):
	if area.is_in_group('camera_target'):
		var start = $start.get_global_transform().origin
		var end = $end.get_global_transform().origin
		Signals.lock_camera.emit(start, end)
