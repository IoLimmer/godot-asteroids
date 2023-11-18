extends Node2D


var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")


func check_child_position(child):
	if child.name == "Player":
		print(child.position)
		
	if child.position.x > SCREEN_WIDTH:
		child.position.x -= SCREEN_WIDTH
	elif child.position.x < 0:
		child.position.x += SCREEN_WIDTH
		
	if child.position.y > SCREEN_HEIGHT:
		child.position.y -= SCREEN_HEIGHT
	elif child.position.y < 0:
		child.position.y += SCREEN_HEIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# in asteroids, if an object moves off one side of the screen, it reappears on the other
	var children = get_children()
	for child in children:
		check_child_position(child)
