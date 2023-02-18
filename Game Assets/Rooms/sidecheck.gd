extends Spatial

var side
var door

func _ready():
	door = get_parent().get_node("Navigation").get_node("NavMesh").get_node("Walls").get_node("%s Wall" %side).get_node("Cutout")
	door.operation = 0
	if side == "North":
		$Sprite3D.modulate = Color(1, 0, 0, 1) # Red
	if side == "South":
		$Sprite3D.modulate = Color(0, 1, 0, 1) # Green
	if side == "East":
		$Sprite3D.modulate = Color(0, 0, 1, 1) # Blue
	if side == "West":
		$Sprite3D.modulate = Color(0, 0, 0, 1) # Black


func _on_Area_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			if body.owner.room_id != get_parent().room_id:
				get_parent().doors[side] = door
				pass

