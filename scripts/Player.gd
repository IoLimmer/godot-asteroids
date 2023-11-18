extends CharacterBody2D


const SPEED = 100.0
const ROTATION_SPEED = 1.5

const SPEED_LERP = .05
const ROTATION_SPEED_LERP = .2

var rotation_direction = 0.0


func get_input():
	rotation_direction = lerp(rotation_direction, Input.get_axis("ui_left", "ui_right"), ROTATION_SPEED_LERP)
	self.velocity = lerp(self.velocity, transform.x * Input.get_axis("ui_down", "ui_up") * SPEED, SPEED_LERP)

func _physics_process(delta):
	get_input()
	self.rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()
