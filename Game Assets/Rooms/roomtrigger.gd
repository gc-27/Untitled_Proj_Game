extends Spatial

func _ready():
	randomize()

func _on_Trigger_body_entered(body):
	if body == global.player:
		body.current_room_id = owner.room_id
		body.current_room = owner
		if not owner.room_cleared:
			owner.start_room()
		else:
			print(owner.doors)
			print(owner.valid_sides)
			print(owner.room_type)
