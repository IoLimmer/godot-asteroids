extends CharacterBody2D


const SPEED = 100.0
const ROTATION_SPEED = 1.5

const SPEED_LERP = .05
const ROTATION_SPEED_LERP = .2

var rotation_direction = 0.0

var Bullet = preload("res://scenes/objects/bullet.tscn")


func get_input():
	rotation_direction = lerp(rotation_direction, Input.get_axis("ui_left", "ui_right"), ROTATION_SPEED_LERP)
	self.velocity = lerp(self.velocity, transform.x * Input.get_axis("ui_down", "ui_up") * SPEED, SPEED_LERP)
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	
func shoot():
	# "Muzzle" is a Marker2D placed at the barrel of the gun.
	var b = Bullet.instantiate()
	b.start($Muzzle.global_position, self.rotation)
	get_tree().root.add_child(b)

func _physics_process(delta):
	get_input()
	self.rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()
