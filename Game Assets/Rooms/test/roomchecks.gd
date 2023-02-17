extends Spatial

func _on_NCheck_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			owner.valid_sides.remove('N')
			print(owner.valid_sides)


func _on_ECheck_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			owner.valid_sides.remove('E')
			print(owner.valid_sides)


func _on_SCheck_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			owner.valid_sides.remove('S')
			print(owner.valid_sides)


func _on_WCheck_body_entered(body):
	if body.owner != null:
		if body.owner.is_in_group("Rooms"):
			owner.valid_sides.remove('W')
			print(owner.valid_sides)
