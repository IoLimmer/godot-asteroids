extends Node2D


var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")

@onready var objs_to_wraparound = get_tree().get_nodes_in_group("wraparound")

var Rock = preload("res://scenes/objects/rock.tscn")
#@onready var Player = get_node("./Player")
var rock_count_on_start = 10
var rocks = []

var Player = preload("res://scenes/objects/player.tscn")


func check_spawn_point():
#	print(objs_to_wraparound)
	var valid = false
	var point = Vector2(0,0)
	while !valid:
		point = Vector2(randi() % SCREEN_WIDTH, randi() % SCREEN_HEIGHT)
		if Geometry2D.is_point_in_polygon(point, $"Spawn Zone".polygon):
			valid = true
	return point

func _ready():
	# generate random positions for rocks, instantiate rocks
	for i in range(rock_count_on_start):
		var rock_position = check_spawn_point()
		var rock_rotation = (randi() % 360) * PI / 180
		var rock_scale = Vector2(1.2, 1.2)
		var rock_speed = 40
		var rock_level = 0
		
		var rock = Rock.instantiate()
		rock.start(rock_position, rock_rotation, rock_scale, rock_speed, rock_level)
		get_node("Rocks").add_child(rock)
		rocks.append(rock)
		rock.add_to_group("wraparound")
	
	# put player in middle of screen facing top
	var player = Player.instantiate()
	player.start()
	self.add_child(player)
#	$Player.position = Vector2(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
#	$Player.rotation += PI/2

# If a child moves off the side of the screen, they wrap back around
func check_child_position(child):
	var sprite = child.get_child(0)
	var sprite_dimensions = Vector2(0,0)
	sprite_dimensions.x = round(sprite.texture.get_width() * child.scale.x * sprite.scale.x)
	sprite_dimensions.y = round(sprite.texture.get_height() * child.scale.y * sprite.scale.y)
	
	# get longer of width and height
	if sprite_dimensions.x > sprite_dimensions.y:
		sprite_dimensions.y = sprite_dimensions.x
	elif sprite_dimensions.y > sprite_dimensions.x:
		sprite_dimensions.x = sprite_dimensions.y
	
	# if a child is off the side of the screen, wraparound to opposite side		
	if child.position.x > SCREEN_WIDTH + sprite_dimensions.x/2:
		child.position.x -= SCREEN_WIDTH + sprite_dimensions.x
	elif child.position.x < 0 - sprite_dimensions.x/2:
		child.position.x += SCREEN_WIDTH + sprite_dimensions.x
		
	if child.position.y > SCREEN_HEIGHT + sprite_dimensions.y/2:
		child.position.y -= SCREEN_HEIGHT + sprite_dimensions.y
	elif child.position.y < 0 - sprite_dimensions.y/2:
		child.position.y += SCREEN_HEIGHT + sprite_dimensions.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	objs_to_wraparound = get_tree().get_nodes_in_group("wraparound")
	# in asteroids, if an object moves off one side of the screen, it reappears on the other
	for obj in objs_to_wraparound:
		check_child_position(obj)
