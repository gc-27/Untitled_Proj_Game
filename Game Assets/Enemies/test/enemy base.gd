extends KinematicBody

var max_health = 25
var health = 25
var move_speed = 5
var contact_damage = 10
var damage_ticks_per_sec = 1

var desired_target
var ownerobj
var dead
var owner_room_id
var nav

var path = []
var cur_path_ind = 0
var velocity = Vector3.ZERO
var threshold = .1
var damaging_player = false
var player = null
var target = null

onready var healthbar = $Viewport/HealthBar
onready var dmgtimer = $DamageTimer

func _ready():
	for room in get_tree().get_nodes_in_group("Rooms"):
		if room.room_id == owner_room_id:
			ownerobj = room
	if dead:
		death()
	else:
		get_target()
		dmgtimer.wait_time = 1.0 / damage_ticks_per_sec
		
func _process(_delta):
	healthbar.value = health
	healthbar.max_value = max_health
	if not dead:
		if health <= 0:
			$Audio.play()
			death()

func damage(dmg):
	health -= dmg
	
func death():
	dead = true
	target = null
	set_collision_layer_bit(2, true)
	set_collision_mask_bit(2, true)
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	$Sprite.scale = Vector3(3, 1, 3)
	$Sprite.transform.origin = Vector3(0, .5, 0)
	$HealthbarSprite.queue_free()

func save():
	var data = {
			"file_name": get_filename(),
			"owner_room_id": ownerobj.room_id,
			"pos_x": transform.origin.x,
			"pos_y": transform.origin.y,
			"pos_z": transform.origin.z,
			"dead": dead,
			"desired_target": desired_target,
			"target": target
	}
	return data

func get_target():
	nav = ownerobj.get_node("%Navigation")
	if desired_target == "Player":
		target = global.player
	elif desired_target == "self":
		target = self
	else:
		target = ownerobj.get_node(desired_target)

func _physics_process(_delta):
	if path.size() > 0 and not dead:
		move_to_target()
	
func move_to_target():
	if not dead:
		if global_transform.origin.distance_to(path[cur_path_ind]) < threshold:
			path.remove(0)
		else:
			var direction = path[cur_path_ind] - global_transform.origin
			velocity = direction.normalized() * move_speed
			return move_and_slide(velocity, Vector3.UP)

func get_target_path(target_pos):
	if not dead:
		path = nav.get_simple_path(global_transform.origin, target_pos)

func _on_NavTimer_timeout():
	if not dead:
		get_target_path(target.global_transform.origin)
	

func _on_Area_body_entered(body):
	if not dead:
		if body == global.player:
			player = body
			player.damage("Enemy", contact_damage)
			dmgtimer.autostart = true
			dmgtimer.start()
			damaging_player = true


func _on_Area_body_exited(body):
	if not dead:
		if body == global.player:
			player = null
			dmgtimer.autostart = false
			dmgtimer.stop()
			damaging_player = false


func _on_DamageTimer_timeout():
	if not dead:
		global.player.damage("Enemy", contact_damage)
