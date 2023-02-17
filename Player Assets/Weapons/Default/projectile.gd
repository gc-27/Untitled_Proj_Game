extends RigidBody

var direction = Vector3()
var s_pos = Vector3()
var speed = 0
var time = 0
var damage = 0
var hitmarker = 0
var hitsound = 0

func _ready():
	for projectile in global.projectile_collision_exceptions:
		add_collision_exception_with(projectile)


func init(look, origin, speed1, dmg, deviation, hm, hs, img):
	global.projectile_collision_exceptions.append(self)
	$AnimationPlayer.play("fire")
	$Sprite.animation = img
	set_as_toplevel(true)
	hitmarker = hm
	hitsound = hs
	speed = speed1
	damage = dmg
	look = look + Vector3(rand_range(deviation[0] * -1, deviation[0])*10, rand_range(deviation[1] * -1, deviation[1])*10, rand_range(deviation[2] * -1, deviation[2])*10)
	transform.origin = origin
	look_at_from_position(origin, look, Vector3.UP)
	
func _physics_process(_delta):
	apply_impulse(transform.basis.z, -transform.basis.z * speed)
	
func _process(delta):
	time += delta
	$OmniLight.light_energy = time
	if time >= 2:
		delete()
		
func delete():
	global.projectile_collision_exceptions.erase(self)
	queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		hitsound.play()
		hitmarker.show()
		hitmarker.scale = Vector2(.25, .25)
		body.damage(damage)
		delete()
	elif body != global.player:
		delete()
