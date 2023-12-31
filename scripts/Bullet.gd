extends CharacterBody2D

const SPEED = 500


func start(_position, _rotation):
	add_to_group("bullets")
	# get angle from player
	self.rotation = _rotation
	# get location from player
	self.position = _position
	self.velocity = Vector2(SPEED, 0).rotated(rotation)
	
func animate():
	$Bullet2.rotate(1)

func _physics_process(delta):
	animate()
	move_and_slide()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
