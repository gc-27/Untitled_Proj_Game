extends Node

var room_id
var room_cleared
var enemies = []
var pickups = []
var valid_sides = []
var room_type
var doors = {
	"N": null,
	"E": null,
	"S": null,
	"W": null,
}
var room_number


# North - 0; East - 1; South - 2; West - 3

func _ready():
	if valid_sides.find('N') != -1:
		doors.N = $"Navigation/NavMesh/Walls/North Wall/Cutout"
	if valid_sides.find('E') != -1:
		doors.E = $"Navigation/NavMesh/Walls/East Wall/Cutout"
	if valid_sides.find('S') != -1:
		doors.S = $"Navigation/NavMesh/Walls/South Wall/Cutout"
	if valid_sides.find('W') != -1:
		doors.W = $"Navigation/NavMesh/Walls/West Wall/Cutout"
	change_doors(0)
	
func start_room():
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
	if not room_cleared:
		if global.player.current_room_id == room_id:
			for enemy in enemies:
				if not enemy.dead:
					return
			clear_room()

func clear_room():
	enemies = []
	spawn_pickups()
	room_cleared = true
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

