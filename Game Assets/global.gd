extends Node
export (Array) var projectile_collision_exceptions = []
export (bool) var loading_from_save = false

var player = ""
var counter = 0
var testing = true
var save_file = 1
onready var world = get_parent().get_node("World")
onready var timer = $Timer

var connecting_sides = {
	"N": "S", 
	"E": "W", 
	"S": "N", 
	"W": "E"
}

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame%s.save" % save_file, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var save_game = File.new()
	if not save_game.file_exists("user://savegame%s.save" % save_file):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame%s.save" % save_file, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["file_name"]).instance()
		new_object.transform.origin = dict_to_vect(node_data)

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "file_name" or i == "pos_x" or i == "pos_y" or i == "pos_x":
				continue
			new_object.set(i, node_data[i])
		world.add_child(new_object)

	save_game.close()

func dict_to_vect(dict):
	return Vector3(dict.pos_x, dict.pos_y, dict.pos_z)
	
	
func start_game():
	world.add_child(load("res://Player Assets/player.tscn").instance())
	player.transform.origin = Vector3(0,1,0)
	if not testing:
		level_generator.generate()
	else:
		var gen_room_pos = Vector3(0,0,0)
		var gen_room = global.read_json("res://Data/rooms_data/difficulty_null.json").test
		var room_name
		for r in global.read_json("res://Data/rooms_data/difficulty_null.json"):
			if r == "test":
				room_name = r
		var room = room_spawner.spawn_room(gen_room, gen_room_pos, room_name)
		gen_room_pos = Vector3(0,0,80)
		gen_room = global.read_json("res://Data/rooms_data/difficulty_null.json").test
		for r in global.read_json("res://Data/rooms_data/difficulty_null.json"):
			if r == "test":
				room_name = r
		room = room_spawner.spawn_room(gen_room, gen_room_pos, room_name)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func scale_array(array):
	var new_array = array
	for i in array[0]:
		new_array.append([])
		for j in array[1]:
			new_array[i].append([])
			for k in array[2]:
				counter += 1
				new_array[i][j].append(counter)
	
	return new_array
			


func read_json(path):
	var file = File.new()
	file.open(path, File.READ)
	return parse_json(file.get_as_text())
