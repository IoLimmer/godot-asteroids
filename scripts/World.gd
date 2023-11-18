extends Node2D


var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")


func check_child_position(child):
	var sprite_width = round(child.get_child(0).texture.get_width() * child.scale.x)
		
	if child.position.x > SCREEN_WIDTH + sprite_width:
		child.position.x -= SCREEN_WIDTH + sprite_width
	elif child.position.x < 0 - sprite_width:
		child.position.x += SCREEN_WIDTH + sprite_width
		
	if child.position.y > SCREEN_HEIGHT + sprite_width:
		child.position.y -= SCREEN_HEIGHT + sprite_width
	elif child.position.y < 0 - sprite_width:
		child.position.y += SCREEN_HEIGHT + sprite_width

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# in asteroids, if an object moves off one side of the screen, it reappears on the other
	var children = get_children()
	for child in children:
		check_child_position(child)
