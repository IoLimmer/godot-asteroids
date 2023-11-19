extends Node2D


var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")

@onready var objs_to_wraparound = get_tree().get_nodes_in_group("wraparound")

var Rock = preload("res://scenes/objects/rock.tscn")
var rock_count_on_start = 4
var rocks = []


func _ready():
	# put player in middle of screen facing top
	$Player.position = Vector2(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	$Player.rotation -= PI/2
	
	# generate random positions for rocks, instantiate rocks
	for i in range(rock_count_on_start):
		var rock_position = Vector2(randi() % SCREEN_WIDTH, randi() % SCREEN_HEIGHT)
		var rock_rotation = (randi() % 360) * PI / 180
		var rock_scale = 1
		var rock = Rock.instantiate()
		rock.start(rock_position, rock_rotation, rock_scale)
		add_child(rock)
		rocks.append(rock)
		rock.add_to_group("wraparound")


func check_child_position(child):
	var sprite = child.get_child(0)
	var sprite_width = Vector2(0,0)
	sprite_width.x = round(sprite.texture.get_width() * child.scale.x * sprite.scale.x)
	sprite_width.y = round(sprite.texture.get_height() * child.scale.y * sprite.scale.y)
	
	# if a child is off the side of the screen, wraparound to opposite side		
	if child.position.x > SCREEN_WIDTH + sprite_width.x/2:
		child.position.x -= SCREEN_WIDTH + sprite_width.x
	elif child.position.x < 0 - sprite_width.x/2:
		child.position.x += SCREEN_WIDTH + sprite_width.x
		
	if child.position.y > SCREEN_HEIGHT + sprite_width.y/2:
		child.position.y -= SCREEN_HEIGHT + sprite_width.y
	elif child.position.y < 0 - sprite_width.y/2:
		child.position.y += SCREEN_HEIGHT + sprite_width.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	objs_to_wraparound = get_tree().get_nodes_in_group("wraparound")
	# in asteroids, if an object moves off one side of the screen, it reappears on the other
	var children = get_children()
	for child in children:
		if child in objs_to_wraparound:
			check_child_position(child)
