extends Spatial


var room_id
var room


func parse_enemy_data(enemydat):
		for enemy in enemydat:
			var spawn = load(enemy.file_name).instance()
			spawn.desired_target = enemy.desired_target
			spawn.owner_room_id = room_id
			spawn.ownerobj = room
			spawn.dead = enemy.dead
			spawn.transform.origin = Vector3(enemy.pos_x, enemy.pos_y, enemy.pos_z)
			room.enemies.append(spawn)
		

func parse_pickup_data(pickupdat):
	for pickup in pickupdat:
		var pickup_dat = global.read_json("res://Data/pickups.json")[pickup.item_name]
		var spawn = load("res://Game Assets/Items/pickup.tscn").instance()
		spawn.transform.origin = Vector3(pickup["pos_x"], pickup["pos_y"], pickup["pos_z"])
		spawn.item_name = pickup.item_name
		spawn.owner_room_id = room_id
		spawn.ownerobj = room
		for value in pickup_dat:
			spawn.set(value, pickup_dat[value])
		room.pickups.append(spawn)


func spawn_room(data, pos, r_name):
	room = load(str(data.path, "room.tscn")).instance()
	room.script = load("res://Game Assets/Rooms/roomscript.gd")
	room.valid_sides = data.valid_sides
	room.room_type = r_name
	room.transform.origin = pos
	room.room_id = randi()
	room.add_to_group("Rooms")
	room.add_to_group("Persist")
	global.world.add_child(room)
	parse_enemy_data(data.enemies)
	parse_pickup_data(data.pickups)
	return room



