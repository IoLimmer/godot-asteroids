extends CharacterBody2D


const SPEED = 100.0
const ROTATION_SPEED = 3

const SPEED_LERP = .04
const ROTATION_SPEED_LERP = 1

var rotation_direction = 0.0
var timeout_shoot = true
var walking = false
var string_directions = ["right", "down", "left", "up"]
var facing_direction = string_directions[1]

var Bullet = preload("res://scenes/objects/bullet.tscn")



func get_input():
	rotation_direction = lerp(rotation_direction, Input.get_axis("ui_left", "ui_right"), ROTATION_SPEED_LERP)
	self.velocity = lerp(self.velocity, transform.x * Input.get_axis("ui_down", "ui_up") * SPEED, SPEED_LERP)
	
	if Input.is_action_pressed("ui_accept") and timeout_shoot:
		$Timer.start()
		shoot()
		timeout_shoot = false
	
func shoot():
	# "Muzzle" is a Marker2D placed at the barrel of the gun.
	var b = Bullet.instantiate()
	b.start($Muzzle.global_position, self.rotation)
	get_tree().root.add_child(b)
	b.add_to_group("bullets")
	
func animate(delta):
	$"knife".position = $Muzzle.position
	if self.rotation_degrees + 180 > 180:
		# put knife in front of player
		$knife.z_index = 1
	else:
		$knife.z_index = 0
		
	# neutralise rotation and position
	$AnimatedSprite2D.rotation -= rotation_direction * ROTATION_SPEED * delta
	$Shadow.rotation -= rotation_direction * ROTATION_SPEED * delta
	
	# get if walking or not
	if Input.get_axis("ui_left", "ui_right") != 0.0 or Input.get_axis("ui_down", "ui_up") != 0.0:
		walking = true
	else:
		walking = false
	
	# get direction
	# 90 is down, 180 is left, -90 is up, 0 is right
	if self.rotation_degrees >= 45 and self.rotation_degrees < 135:
		facing_direction = string_directions[1]
	elif self.rotation_degrees >= 135 or self.rotation_degrees < -135:
		facing_direction = string_directions[2]
	elif self.rotation_degrees >= -135 and self.rotation_degrees < -45:
		facing_direction = string_directions[3]
	elif self.rotation_degrees >= -45 and self.rotation_degrees < 45:
		facing_direction = string_directions[0]
	
	# set animation
	if walking:
		$AnimatedSprite2D.play("walk_"+facing_direction)
	elif !walking:
		$AnimatedSprite2D.play("idle_"+facing_direction)		

func _physics_process(delta):
	get_input()
	self.rotation += rotation_direction * ROTATION_SPEED * delta
#	print(self.rotation_degrees)
	animate(delta)
	move_and_slide()

func _on_timer_timeout():
	timeout_shoot = true

