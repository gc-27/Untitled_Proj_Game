extends Node

var room_id
var room_cleared = false
var enemies = []
var pickups = []
var valid_sides = []
var room_type
var ready
var doors = {
	"North": null,
	"East": null,
	"South": null,
	"West": null,
}
var room_number


# North - 0; East - 1; South - 2; West - 3

func _ready():
	if valid_sides.find('N') != -1:
		var north_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		north_check.transform.origin = Vector3(0, 0, -80)
		north_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		north_check.v = "North"
		add_child(north_check)
	if valid_sides.find('E') != -1:
		var east_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		east_check.transform.origin = Vector3(80, 0, 0)
		east_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		east_check.v = "East"
		add_child(east_check)
	if valid_sides.find('S') != -1:
		var south_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		south_check.transform.origin = Vector3(0, 0, 80)
		south_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		south_check.v = "South"
		add_child(south_check)
	if valid_sides.find('W') != -1:
		var west_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		west_check.transform.origin = Vector3(-80, 0, 0)
		west_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		west_check.v = "West"
		add_child(west_check)
	global.timer.wait_time = .1
	global.timer.start()
	yield(global.timer, "timeout")
	ready = true
	if room_type == "starting_room":
		print(doors)
	change_doors(2)
	
func start_room():
	room_cleared = false
	change_doors(0)
	global.player.current_room_id = room_id
	global.player.current_room = self
	spawn_enemies()
			
func spawn_enemies():
	for enemy in enemies:
		add_child(enemy)

func spawn_pickups():
	for pickup in pickups:
		add_child(pickup)
			

func _process(_delta):
	if ready:
		if enemies == [] and not room_cleared:
			clear_room()
		if not room_cleared:
			if global.player.current_room_id == room_id:
				for enemy in enemies:
					if not enemy.dead:
						return
				clear_room()

func clear_room():
	room_cleared = true
	change_doors(2)
	enemies = []
	spawn_pickups()
	global.save_game()

func save():
	var save_dict = {
		"room_id": room_id,
		"file_name": get_filename(),
		"enemies": enemies,
		"pickups": pickups,
		"room_cleared": room_cleared,
		"pos_x": self.transform.origin.x,
		"pos_y": self.transform.origin.y,
		"pos_z": self.transform.origin.z,
		"valid_sides": valid_sides,
		"room_type": room_type
		}
	return save_dict
	

func change_doors(value):
	for door in doors:
		if doors[door] != null:
			doors[door].operation = value

