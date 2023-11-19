extends Area2D

var SPEED = 50
const LERP = .1

var velocity = Vector2(0,0)


func start(_position, _rotation, _scale, _speed):
	# get angle
	self.rotation = _rotation
	# get location
	self.position = _position
	self.scale = _scale
	SPEED = _speed


func _process(delta):
	velocity = lerp(velocity, Vector2(1, 0).rotated(self.rotation) * SPEED * delta, LERP)
	self.position += velocity

func _on_body_entered(body):
	var bullets = get_tree().get_nodes_in_group("bullets")
	if body in bullets:
		body.queue_free()
		queue_free()
