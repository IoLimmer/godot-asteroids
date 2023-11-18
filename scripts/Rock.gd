extends CharacterBody2D


const SPEED = 50
const LERP = .1

func _process(delta):
	self.velocity = lerp(self.velocity, transform.x * Vector2(1, 0) * SPEED, LERP)
	move_and_slide()
