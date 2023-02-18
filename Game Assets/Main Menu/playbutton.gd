extends Button


func _ready():
	pass

func _on_Play_Button_pressed():
	owner.hide()
	global.start_game()

func _on_Play_Save_Button_pressed():
	owner.hide()
	global.loading_from_save = true
	global.load_game()
