extends KinematicBody

var max_health
var max_health_mod
var health
var move_speed
var move_speed_mod
var jump_height
var jump_height_mod
var proj_speed
var proj_speed_mod
var proj_cd
var proj_cd_mod
var proj_damage
var proj_damage_mod
var technique_cd
var technique_cd_mod
var technique_current_cd
var proj_deviation
var current_room_id
var current_room
var mouse_sensitivity
var health_removal = 0

var hit_marker
var hit_sound 
var weapon_sprite


var projectile_properties
var class_properties
var usable_weapons
var projectile
var technique
var cfg


var weapon = "default"
var player_class = "archmage"
var cooldown = load("res://player assets/cooldown.gd")
var primary_cooldown

var gravity = 30
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
var full_contact = false
var air_accel = 3
var h_accel = -10
var normal_accel = 8
var technique_ready = false
var technique_in_use = false

var items = []

onready var head = $Head
onready var ground_check = $GroundCheck
onready var aimpoint = $Head/AimPoint
onready var firepoint = $Head/FirePoint
onready var camera = $Head/Camera
onready var audio = $AudioStreamPlayer3D
onready var world = get_parent()


func _init():
	global.player = self

func _ready():
	scale = Vector3(2, 2, 2)
	weapon_sprite.animation = weapon
	projectile_properties = global.read_json(str("res://data/d1.json")).weapons[weapon]
	class_properties = global.read_json(str("res://data/d1.json")).classes[player_class]
	cfg = global.read_json(str("res://data/cfg.json"))
	read_audio(str(projectile_properties.path, "/fire.mp3"))
	assign_weapon_vars(projectile_properties)
	assign_player_vars(class_properties)
	assign_cfg()

func assign_weapon_vars(source):
	projectile = load(str(source.path, "/projectile.tscn"))
	technique = load(str(source.path, "/technique.tscn")).instance()
	self.add_child(technique)
	for value in source:
		if value != "projectile" and value != "proj_deviation":
			set(value, source[value])
	proj_deviation = global.dict_to_vect(source.deviation)
	if not global.loading_from_save:
		proj_speed_mod = 0
		proj_cd_mod = 0
		proj_damage_mod = 0
		technique_cd_mod = 0
		technique_current_cd = technique_cd + technique_cd_mod
	primary_cooldown = cooldown.new((proj_cd + proj_cd_mod) * .001)


func assign_player_vars(source):
	for value in source:
		set(value, source[value])
	if not global.loading_from_save:
		max_health_mod = 0
		health = source.max_health
		move_speed_mod = 15
		jump_height_mod = 30


func assign_cfg():
	for value in cfg:
		set(value, cfg[value])

func save():
	var save_dict = {
		"file_name": get_filename(),
		"player_class": player_class,
		"current_room_id": current_room_id,
		"pos_x": transform.origin.x,
		"pos_y": transform.origin.y,
		"pos_z": transform.origin.z,
		"move_speed_mod": move_speed_mod,
		"proj_speed_mod": proj_speed_mod,
		"proj_cd_mod": proj_cd_mod,
		"proj_damage_mod": proj_damage_mod,
		"technique_cd_mod": technique_cd_mod,
		"jump_height_mod": jump_height_mod,
		"max_health_mod": max_health_mod,
		"proj_deviation": proj_deviation,
		"technique_current_cd": technique_current_cd,
		"health": health
	}
	return save_dict

func read_audio(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, file.READ)
		var buffer = file.get_buffer(file.get_len())
		var stream = AudioStreamMP3.new()
		stream.data = buffer
		audio.stream = stream


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))


func _process(delta):
	primary_cooldown.tick(delta)
	if Input.is_mouse_button_pressed(1):
		if primary_cooldown.is_ready():
			weapon_sprite.frame = 2
			audio.play()
			var proj = projectile.instance()
			
			proj.init(
			aimpoint.global_transform.origin, 
			firepoint.global_transform.origin, 
			proj_speed + proj_speed_mod, 
			proj_damage + proj_damage_mod, 
			proj_deviation, 
			hit_marker, 
			hit_sound, 
			weapon
			)
			
			world.add_child(proj)
			
	else:
		weapon_sprite.frame = 0


	if Input.is_action_just_pressed("console"):
		pass
	if Input.is_action_just_pressed("technique") and technique_ready and not technique_in_use:
		technique.use()
		technique_ready = false
		technique_in_use = true
		
	if technique_current_cd > 0:
		technique_current_cd -= delta
	else:
		technique_current_cd = 0
		technique_ready = true

	if health > max_health + max_health_mod:
		health_removal += delta
		if health_removal > 1:
			health_removal = 1
			health -= health_removal
			health_removal = 0
			


func damage(_source, dmg):
	health -= dmg
	#more later


func _physics_process(delta):
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_accel = air_accel
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_accel = normal_accel
	else:
		gravity_vec = -get_floor_normal()
		h_accel = normal_accel
	
	if Input.is_action_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * (jump_height + jump_height_mod)
	camera.rotation.z = clamp(camera.rotation.z, deg2rad(-.5), deg2rad(.5))
	if Input.is_action_pressed("wiz_forward"):
		direction -= transform.basis.z 
	if Input.is_action_pressed("wiz_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("wiz_left"):
		camera.rotate_z(.001)
		direction -= transform.basis.x
	elif Input.is_action_pressed("wiz_right"):
		camera.rotate_z(-.001)
		direction += transform.basis.x
	else:
		if camera.rotation.z < 0:
			camera.rotate_z(.001)
			camera.rotation.z = clamp(camera.rotation.z, deg2rad(-.5), deg2rad(0))
		if camera.rotation.z > 0:
			camera.rotate_z(-.001)
			camera.rotation.z = clamp(camera.rotation.z, deg2rad(0), deg2rad(.5))
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * (move_speed + move_speed_mod), h_accel * delta)
	
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	return move_and_slide(movement, Vector3.UP)
