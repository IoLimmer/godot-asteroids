extends CharacterBody2D


const SPEED = 100.0
const ROTATION_SPEED = 1.5
const LERP = .05

var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	self.velocity = lerp(self.velocity, transform.x * Input.get_axis("ui_down", "ui_up") * SPEED, LERP)

func _physics_process(delta):
	get_input()
	self.rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()
