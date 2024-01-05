extends Node


const default_score = 0
const default_lives = 3
const default_running = true

var score
var lives
var running

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
#	pass # Replace with function body.
	
func reset():
	score = default_score
	lives = default_lives
	running = default_running


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lives <= 0:
		running = false
