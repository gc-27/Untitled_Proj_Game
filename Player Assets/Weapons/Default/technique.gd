extends Spatial

onready var timer = $Timer

func _ready():
	pass

func use():
	global.player.health += 20
	global.player.move_speed_mod += 5
	timer.wait_time = 4
	timer.start()
	yield(timer, "timeout")
	global.player.move_speed_mod -= 5
	global.player.technique_current_cd = global.player.technique_cd + global.player.technique_cd_mod
	global.player.technique_ready = false
	global.player.technique_in_use = false
