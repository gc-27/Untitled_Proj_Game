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
	print(self)
	if valid_sides.find('N') != -1:
		$"Navigation/NavMesh/Walls/North Wall/Cutout".operation = 0
		var north_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		north_check.transform.origin = Vector3(0, 0, -45)
		north_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		north_check.side = "North"
		add_child(north_check)
	if valid_sides.find('E') != -1:
		$"Navigation/NavMesh/Walls/East Wall/Cutout".operation = 0
		var east_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		east_check.transform.origin = Vector3(45, 0, 0)
		east_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		east_check.side =  "East"
		add_child(east_check)
	if valid_sides.find('S') != -1:
		$"Navigation/NavMesh/Walls/South Wall/Cutout".operation = 0
		var south_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		south_check.transform.origin = Vector3(0, 0, 45)
		south_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		south_check.side = "South"
		add_child(south_check)
	if valid_sides.find('W') != -1:
		$"Navigation/NavMesh/Walls/West Wall/Cutout".operation = 0
		var west_check = load('res://Game Assets/Rooms/generation/roomcheck.tscn').instance()
		west_check.transform.origin = Vector3(-45, 0, 0)
		west_check.script = load('res://Game Assets/Rooms/sidecheck.gd')
		west_check.side = "West"
		add_child(west_check)
	global.timer.wait_time = .1
	global.timer.start()
	yield(global.timer, "timeout")
	ready = true
	if enemies == []:
		clear_room()
	
func start_room():
	room_cleared = false
	change_doors(0)
	spawn_enemies()
			
func spawn_enemies():
	for enemy in enemies:
		add_child(enemy)

func spawn_pickups():
	for pickup in pickups:
		add_child(pickup)
			

func _process(_delta):
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

