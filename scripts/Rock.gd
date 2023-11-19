extends Area2D


const SPEED = 50
const LERP = .1

var velocity = Vector2(0,0)

func _process(delta):
	velocity = lerp(velocity, Vector2(1, 0) * SPEED * delta, LERP)
	self.position += velocity

func _on_body_entered(body):
	var bullets = get_tree().get_nodes_in_group("bullets")
	if body in bullets:
		queue_free()
