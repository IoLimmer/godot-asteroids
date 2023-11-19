extends CharacterBody2D


const SPEED = 500


func start(_position, _rotation):
	# get angle from player
	self.rotation = _rotation
	# get location from player
	self.position = _position
	self.velocity = Vector2(SPEED, 0).rotated(rotation)

func _physics_process(delta):
	move_and_slide()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()
