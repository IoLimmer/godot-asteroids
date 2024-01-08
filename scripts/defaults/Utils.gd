extends Node


const default_score = 0
const default_lives = 3
const default_running = true
const default_rock_count_on_start = 1

var score
var lives
var running
var rock_count_on_start

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func reset():
	score = default_score
	lives = default_lives
	running = default_running
	rock_count_on_start = default_rock_count_on_start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lives <= 0:
		running = false
