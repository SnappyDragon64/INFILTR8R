extends Control

var paused = false
var dead = false

func _ready():
	Signals.change_level.connect(_update_lv_label)
	Signals.update_health.connect(_update_hp_label)
	Signals.update_mana.connect(_update_mp_label)
	Signals.hurt.connect(_ouch)
	Signals.death.connect(_handle_death)
	Signals.reload_level.connect(_reset_colors)
	Signals.mp_broke.connect(_broke)

func _process(_delta):
	if Input.is_action_just_pressed('pause'):
		if dead:
			dead = false
			$notification_container/label.set_text('')
			Signals.change_track.emit(0)
			Signals.reload_level.emit()
			_update_hp_label(1, 1)
			_update_mp_label(1, 1)
		else:
			if paused:
				$notification_container/label.set_text('')
				get_tree().paused = false
				paused = false
			else:
				$notification_container/label.set_text('[SYSTEM SUSPENDED]')
				get_tree().paused = true
				paused = true

func _handle_death():
	$notification_container/label.set_text('[CONNECTION TERMINATED]')
	$stat_container/hp_value.add_theme_color_override('font_color', Color('ff0000'))
	Signals.change_track.emit(2)
	dead = true

func _update_lv_label(level, _spawnpoint):
	$level_container/lv_label.set_text(level.get_state().get_node_name(0))
	
func _update_hp_label(health, max_health):
	var value = health * 100 / max_health
	$stat_container/hp_value.set_text('{0}%'.format({'0': value}))
	
func _update_mp_label(mana, max_mana):
	var value = mana * 100 / max_mana
	$stat_container/mp_value.set_text('{0}%'.format({'0': value}))

func _ouch():
	$stat_container/hp_value.add_theme_color_override('font_color', Color('ff0000'))
	$reset_hp_value_color.start()

func _on_reset_hp_value_color_timeout():
	$stat_container/hp_value.add_theme_color_override('font_color', Color('000000'))

func _reset_colors():
	$stat_container/hp_value.add_theme_color_override('font_color', Color('000000'))
	$stat_container/mp_value.add_theme_color_override('font_color', Color('000000'))

func _broke():
	$stat_container/mp_value.add_theme_color_override('font_color', Color('ff0000'))
	$reset_mp_value_color.start()

func _on_reset_mp_value_color_timeout():
	$stat_container/mp_value.add_theme_color_override('font_color', Color('000000'))
