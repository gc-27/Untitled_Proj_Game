extends Node

var room_count = 10
var difficulty = 1
var difficulty_str = "difficulty_1"
var room
var gen_room
var room_name
var door = ""
var gen_room_pos = Vector3()
var possible_rooms = []
var rooms = {}
var north_invalid = false
var east_invalid = false
var south_invalid = false
var west_invalid = false
var up_invalid = false
var down_invalid = false
var checkerN
var checkerE
var checkerS
var checkerW
var connecting_sides = {
	"N": "S",
	"S": "N",
	"E": "W",
	"W": "E",
	"D": "U",
	"U": "D"
}
var side_origins = {
	"N": [0,0,-80],
	"W": [-80,0,0],
	"S": [0,0,80],
	"E": [80,0,0],
	"U": [0,80,0],
	"D": [0,-80,0]
}


func _ready():
	rooms = global.read_json(str("res://data/rooms_data/", difficulty_str, ".json"))
	checkerN = load("res://Game Assets/Rooms/generation/roomcheck.tscn").instance()
	checkerN.script = load("res://Game Assets/Rooms/generation/roomcheck.gd")
	checkerN.v = "north_invalid"
	global.world.add_child(checkerN)
	
	checkerE = load("res://Game Assets/Rooms/generation/roomcheck.tscn").instance()
	checkerE.script = load("res://Game Assets/Rooms/generation/roomcheck.gd")
	checkerE.v = "east_invalid"
	global.world.add_child(checkerE)
	
	checkerS = load("res://Game Assets/Rooms/generation/roomcheck.tscn").instance()
	checkerS.script = load("res://Game Assets/Rooms/generation/roomcheck.gd")
	checkerS.v = "south_invalid"
	global.world.add_child(checkerS)
	
	checkerW = load("res://Game Assets/Rooms/generation/roomcheck.tscn").instance()
	checkerW.script = load("res://Game Assets/Rooms/generation/roomcheck.gd")
	checkerW.v = "west_invalid"
	global.world.add_child(checkerW)

func check_room_sides(pos):
	randomize()
	checkerN.transform.origin = Vector3(pos.x + side_origins.N[0],0,pos.z+ side_origins.N[2])
	checkerE.transform.origin = Vector3(pos.x + side_origins.E[0],0,pos.z+ side_origins.E[2])
	checkerS.transform.origin = Vector3(pos.x + side_origins.S[0],0,pos.z+ side_origins.S[2])
	checkerW.transform.origin = Vector3(pos.x + side_origins.W[0],0,pos.z+ side_origins.W[2])
	if north_invalid:
		if room.valid_sides.find('N') != -1:
			room.valid_sides.erase('N')
		north_invalid = false
	if east_invalid:
		if room.valid_sides.find('E') != -1:
			room.valid_sides.erase('E')
		east_invalid = false
	if south_invalid:
		if room.valid_sides.find('S') != -1:
			room.valid_sides.erase('S')
		south_invalid = false
	if west_invalid:
		if room.valid_sides.find('W') != -1:
			room.valid_sides.erase('W')
		west_invalid = false
		

func get_door():
	if room.valid_sides == []:
		new_door()
	door = room.valid_sides[randi() % room.valid_sides.size()]
	for r in rooms:
		rooms = global.read_json(str("res://data/rooms_data/", difficulty_str, ".json"))
		if rooms[r].valid_sides.find(connecting_sides[door]) != -1:
			possible_rooms.append(r)
	gen_room = possible_rooms[randi() % possible_rooms.size()]
	room_name = gen_room
	gen_room = rooms[gen_room]
	possible_rooms = []
	gen_room_pos = Vector3(room.transform.origin.x + side_origins[door][0],0,room.transform.origin.z+ side_origins[door][2])
	for r in get_tree().get_nodes_in_group("Rooms"):
		if r.transform.origin != gen_room_pos:
			room = r
		else:
			new_door()
			get_door()

func new_door():
	var temp = []
	for r in get_tree().get_nodes_in_group("Rooms"):
		if r.valid_sides != []:
			temp.append(r)
	room = temp[randi() % temp.size()]

func generate():
	gen_room_pos = Vector3(0,0,0)
	gen_room = global.read_json("res://Data/rooms_data/difficulty_null.json").starting_room
	room_name = "starting_room"
	for i in room_count:
		randomize()
		checkerN.transform.origin = Vector3(gen_room_pos.x + side_origins.N[0],0,gen_room_pos.z+ side_origins.N[2])
		checkerE.transform.origin = Vector3(gen_room_pos.x + side_origins.E[0],0,gen_room_pos.z+ side_origins.E[2])
		checkerS.transform.origin = Vector3(gen_room_pos.x + side_origins.S[0],0,gen_room_pos.z+ side_origins.S[2])
		checkerW.transform.origin = Vector3(gen_room_pos.x + side_origins.W[0],0,gen_room_pos.z+ side_origins.W[2])
		room = room_spawner.spawn_room(gen_room, gen_room_pos, room_name)
		if door == "":
			global.player.current_room = room
			global.player.current_room_id = room.room_id
		check_room_sides(gen_room_pos)
		checkerW.show()
		checkerN.show()
		checkerE.show()
		checkerS.show()
		get_door()
	
