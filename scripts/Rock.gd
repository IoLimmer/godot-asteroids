extends Area2D

var SPEED = 10
const LERP = .1

var sprite_rotation_speed = 1

var velocity = Vector2(0,0)
var level = 0
var sprite_random = 0

var Rock = preload("res://scenes/objects/rock.tscn")
#@onready var Player = get_tree().get_nodes_in_group("player")
var rocks = []


func start(_position, _rotation, _scale, _speed, _level):
#	print(Player)
	# get angle
	self.rotation = _rotation
	# get location
	self.position = _position
	self.scale = _scale
	SPEED = _speed + (randf_range(-1,1) * _speed/3)
	level = _level
	var rng = RandomNumberGenerator.new()
	sprite_rotation_speed = rng.randf_range(1.0, 5.0)

func _process(delta):
	if Utils.running:
		animate()
		velocity = lerp(velocity, Vector2(1, 0).rotated(self.rotation) * SPEED * delta, LERP)
		self.position += velocity
	
func spawn_debris():
	# instantiate two new smaller rocks
	for i in range(2):
		var rock_position = self.position
		var rock_rotation = (randi() % 360) * PI / 180
		var rock_scale = self.scale / 1.5
#		var rock_scale = self.scale
		var rock_speed = SPEED * 1.5
		var rock_level = level + 1
		
		var rock = Rock.instantiate()
		rock.start(rock_position, rock_rotation, rock_scale, rock_speed, rock_level)
		get_parent().add_child(rock)
		rocks.append(rock)
		rock.add_to_group("wraparound")

func animate():
	$RockShadow.global_position = self.global_position + Vector2(-5, 5)
	$RockAnimatedSprite2D.play(str(level) + "_" + str(sprite_random))
	

func _on_body_entered(body):
#	print(body)
#	print(body.dead)
#	try:
#		prin
	var bullets = get_tree().get_nodes_in_group("bullets")
	var players = get_tree().get_nodes_in_group("player")
	
	if body in bullets:
		if level < 2:
			spawn_debris()
		# delete self and bullet
		Utils.score = Utils.score + (50 * (self.level+1))
		body.queue_free()
		queue_free()
	if body in players and !body.dead and !body.invincible:
#		body.queue_free()
		body.kill(self.rotation)
		
