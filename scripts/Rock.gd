extends Area2D

var SPEED = 50
const LERP = .1

var velocity = Vector2(0,0)

var Rock = preload("res://scenes/objects/rock.tscn")
var rocks = []


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
	
func spawn_debris():
	# instantiate two new smaller rocks
	for i in range(2):
		var rock_position = self.position
		var rock_rotation = (randi() % 360) * PI / 180
		var rock_scale = self.scale / 2
		var rock_speed = SPEED * 1.5
		
		var rock = Rock.instantiate()
		rock.start(rock_position, rock_rotation, rock_scale, rock_speed)
		get_parent().add_child(rock)
		rocks.append(rock)
		rock.add_to_group("wraparound")

func _on_body_entered(body):
	var bullets = get_tree().get_nodes_in_group("bullets")
	if body in bullets:
		spawn_debris()
		# delete self and bullet
		body.queue_free()
		queue_free()
