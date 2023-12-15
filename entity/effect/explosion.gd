extends Node2D

func _ready():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(100, 100), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", PI, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_property(self, "modulate", Color(1, 1, 1, 0), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(self.queue_free)
