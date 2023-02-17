extends Spatial

var north_enabled
var east_enabled
var south_enabled
var west_enabled


var current_door = ""
var text = global.player.get_node("Head/HUD/InteractText")

func _on_NTrigger_body_entered(body):
	if north_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = "Press F to open door."
					current_door = "N"

func _on_NTrigger_body_exited(body):
	if north_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = ""
					current_door = ""

func _on_ETrigger_body_entered(body):
	if east_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = "Press F to open door."
					current_door = "E"
			
func _on_ETrigger_body_exited(body):
	if east_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = ""
					current_door = ""

func _on_STrigger_body_entered(body):
	if south_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = "Press F to open door."
					current_door = "S"
			
func _on_STrigger_body_exited(body):
	if south_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = ""
					current_door = ""

func _on_WTrigger_body_entered(body):
	if west_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = "Press F to open door."
					current_door = "W"
			
func _on_WTrigger_body_exited(body):
	if west_enabled:
		if global.player.current_room_id == owner.room_id:
			if body == global.player:
				if owner.room_cleared:
					text.text = ""
					current_door = ""
				
				

