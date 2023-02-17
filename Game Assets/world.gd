extends Spatial


func _ready():
	var gui = load("res://Game Assets/Main Menu/menu.tscn").instance()
	add_child(gui)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
