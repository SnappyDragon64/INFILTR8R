extends Node

# SHADER
signal set_recolor_mode(id)

# LEVEL
signal change_level(scene, spawnpoint)
signal reload_level()
signal spawn(object)

# PLAYER
signal set_player_position(position)
signal position_updated(position)
signal update_health(health, max_health)
signal update_mana(mana, max_mana)
signal hurt()
signal death()
signal mp_broke()
signal heavy()
signal kill()
signal god_mode(duration)
signal controller_mode(flag)

# EVENT
signal event(id)

# CAMERA
signal lock_camera(start, end)
signal set_zoom(zoom_vector)

# BOSS
signal boss_position_updated(position)

# AUDIO
signal change_track(id)
