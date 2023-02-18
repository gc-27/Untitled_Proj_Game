extends Control

var save_1_exists
var save_2_exists
var save_3_exists

var previous_menus = []
var current_menu




func _ready():
	pass

func _on_Play_Button_pressed():
	$Title.hide()
	$"Play Button".hide()
	$SaveButtons.show()
	var save_game = File.new()
	
	save_1_exists = save_game.file_exists("user://savegame1.save")
	$SaveButtons/SaveButton1.text = "Load Game" if save_1_exists else "New Game"
	
	save_2_exists = save_game.file_exists("user://savegame2.save")
	$SaveButtons/SaveButton2.text = "Load Game" if save_2_exists else "New Game"
	
	save_3_exists = save_game.file_exists("user://savegame3.save")
	$SaveButtons/SaveButton3.text = "Load Game" if save_3_exists else "New Game"






func _on_SaveButton1_pressed():
	hide()
	global.save_file = 1
	if save_1_exists:
		global.loading_from_save = true
		global.load_game()
	else:
		global.start_game()

func _on_SaveButton2_pressed():
	hide()
	global.save_file = 2
	if save_2_exists:
		global.loading_from_save = true
		global.load_game()
	else:
		global.start_game()

func _on_SaveButton3_pressed():
	hide()
	global.save_file = 3
	if save_3_exists:
		global.loading_from_save = true
		global.load_game()
	else:
		global.start_game()

