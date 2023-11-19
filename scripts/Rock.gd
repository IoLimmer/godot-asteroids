extends Area2D


const SPEED = 5
const LERP = .1

var velocity = Vector2(0,0)

func _process(delta):
	velocity = lerp(velocity, Vector2(1, 0) * SPEED, LERP)
	self.position += velocity
