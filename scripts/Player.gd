extends CharacterBody2D


const SPEED = 100.0
const ROTATION_SPEED = 3

const SPEED_LERP = .04
const ROTATION_SPEED_LERP = 1

var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")

var rotation_direction = 0.0
var forward_backwards = 0.0

var timeout_shoot = true
var walking = false
var dead = false
var invincible = false

var string_directions = ["right", "down", "left", "up"]
var facing_direction = string_directions[1]

var knockback_angle = 0.0

var Bullet = preload("res://scenes/objects/bullet.tscn")
#var Player = preload("res://scenes/objects/player.tscn")



func start(invincible_setter, parent):
	
	invincible = invincible_setter
	self.position = Vector2(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	self.rotation_degrees = 90
	$AnimatedSprite2D.rotation_degrees = -90
	$Shadow.rotation_degrees = -90
	self.find_child("AnimatedSprite2D").play("idle_down")
	self.add_to_group("wraparound")
	
	self.add_to_group("player")

	
	parent.add_child(self)
	$SFX/respawn.play()
#	print("RESPAWN")
#	print("invincible = ", invincible)
##	print(get_tree())
##	print()
	await get_tree().create_timer(3.0).timeout
	invincible = false
	


func get_input():
	if !dead:
		rotation_direction = lerp(rotation_direction, Input.get_axis("ui_left", "ui_right"), ROTATION_SPEED_LERP)
		forward_backwards = Input.get_axis("ui_down", "ui_up");
		self.velocity = lerp(self.velocity, self.transform.x * forward_backwards * SPEED, SPEED_LERP)
	elif dead:
#		self.rotation = knockback_angle
#		knockback_velocity = lerp(knockback_velocity, transform.x * SPEED, SPEED_LERP)
		self.velocity = lerp(self.velocity, Vector2(0.0, 0.0), SPEED_LERP)
	
	if Input.is_action_pressed("ui_accept") and timeout_shoot and !dead:
		$Timer.start()
		shoot()
		timeout_shoot = false


func shoot():
	# "Muzzle" is a Marker2D placed at the barrel of the gun.
	var b = Bullet.instantiate()
	b.start($Muzzle.global_position, self.rotation)
	get_tree().root.add_child(b)
	b.add_to_group("bullets")

	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randfn(0, 0.2)
	$SFX/bullet.pitch_scale = 1 + my_random_number
#	print($SFX/bullet.pitch_scale)
	$SFX/bullet.play()


func kill(rock_angle):
	dead = true
#	print(rock_angle)
#	print()
#	knockback_angle = rock_angle
	# do animation knockback and make player non collidable
	self.rotation = rock_angle
	rotation_direction = 0.0
	self.velocity = self.transform.x * SPEED
#	$CollisionShape2D.layer

	# play kill sfx
	$SFX/killed.play()

	# wait two seconds then despawn
	
#	print(get_tree())
#	print()
	await get_tree().create_timer(2.0).timeout
	Utils.lives -= 1
#	print(Utils.lives)

	if Utils.lives > 0:
		self.queue_free()
#		var player = Player.instantiate()
		var player = self.duplicate()
	#	player.position = Vector2(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
		player.start(true, get_parent())
	


func animate(delta):
#	print("$knife.z_index = ", $knife.z_index)
#	print("$AnimatedSprite2D.z_index = ", $AnimatedSprite2D.z_index)
	$knife.position = $Muzzle.position
	if self.rotation_degrees + 180 > 180 and !dead:
		# put knife in front of player
		$knife.z_index = 1
	else:
		$knife.z_index = 0
	if dead:
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
	if !dead:
		if walking:
			$AnimatedSprite2D.play("walk_"+facing_direction)
		elif !walking:
			$AnimatedSprite2D.play("idle_"+facing_direction)
	else:
		$AnimatedSprite2D.play("dead")
		$knife.z_index = 0
	
	if !Utils.running:
		$AnimatedSprite2D.modulate.a = 1.0
		$knife.modulate.a = 1.0
#		$Shadow.modulate.a = 1.0
	elif invincible:
		$AnimatedSprite2D.z_index = 1
		$AnimatedSprite2D.modulate.a = 0.5
		$knife.z_index += 1
		$knife.modulate.a = 0.5
	else:
		$AnimatedSprite2D.z_index = 0
		$AnimatedSprite2D.modulate.a = 1
		$knife.modulate.a = 1		
		$Shadow.modulate.a = 1.0
#		$knife.z_index = 0


#	if !Utils.running:
#		print("$AnimatedSprite2D.z_index = ", $AnimatedSprite2D.z_index)
#		print("$knife.z_index = ", $knife.z_index)
#		print("$Shadow.z_index = ", $Shadow.z_index)
	
		


func _physics_process(delta):
	
#	print("invincible = ", invincible)
	get_input()
	self.rotation += rotation_direction * ROTATION_SPEED * delta
#	if dead:
#		rotation_direction = 0.0
	animate(delta)
	move_and_slide()
	
#	print(self.rotation_degrees)


func _on_timer_timeout():
	timeout_shoot = true

