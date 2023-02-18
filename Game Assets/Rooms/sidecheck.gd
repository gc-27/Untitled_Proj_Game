extends Spatial

var v
var door

func _ready():
	door = get_parent().get_node("Navigation").get_node("NavMesh").get_node("Walls").get_node("%s Wall" %v).get_node("Cutout")
	door.operation = 0


func _on_Area_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			if body.owner.room_id != get_parent().room_id:
				get_parent().doors[v] = door
				pass

