extends Spatial

func _ready():
	randomize()

func _on_Trigger_body_entered(body):
	if body == global.player:
		if not owner.room_cleared and body.current_room_id != owner.room_id:
			owner.start_room()
