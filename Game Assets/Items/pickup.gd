extends Spatial

var stat_mods = {
	"max_health_mod": 0,
	"health": 0,
	"move_speed_mod": 0,
	"jump_height_mod": 0,
	"proj_speed_mod": 0,
	"proj_cd_mod": 0,
	"proj_damage_mod": 0,
	"technique_cd_mod": 0,
	"technique_current_cd": 0,
	"proj_deviation": 0,
	}


var item_name
var ownerobj
var owner_room_id

func save():
	var save_dict = {
		"file_name": get_filename(),
		"item_name": item_name,
		"owner_room_id": ownerobj.room_id,
		"pos_x": transform.origin.x,
		"pos_y": transform.origin.y,
		"pos_z": transform.origin.z,
		"stat_mods": stat_mods
	}
	return save_dict

func _ready():
	$Sprite.texture = load(str("res://Game Assets/Items/", item_name, "/", item_name, ".png"))
	for room in get_tree().get_nodes_in_group("Rooms"):
		if room.room_id == owner_room_id:
			ownerobj = room
	$AnimationPlayer.play("animation")


func pick_up():
	for value in stat_mods:
		if value != "proj_deviation":
			global.player.set(value, stat_mods[value] + global.player.get(value))
	global.player.proj_deviation += global.dict_to_vect(stat_mods.proj_deviation)
	global.player.items.append(name)
	self.remove_from_group("Persist")
	queue_free()
	global.save_game()


func _on_Area_body_entered(body):
	if body == global.player:
		pick_up()
