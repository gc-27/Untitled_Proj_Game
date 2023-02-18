extends Spatial

var v

func _on_Area_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			get_parent().doors.remove(v)
			pass

