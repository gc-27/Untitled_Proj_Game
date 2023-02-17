extends Sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if scale > Vector2(0, 0):
		scale -= Vector2(.025, .025)
	else: hide()
	
