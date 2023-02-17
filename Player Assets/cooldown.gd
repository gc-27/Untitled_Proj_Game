var time = 0
var max_time = 0

func _init(mt):
	self.max_time = mt
	self.time = 0
	
func is_ready():
	if time >0:
		return false
	time = max_time
	return true
	
func tick(delta):
	time = max(time - delta, 0)
