extends Node2D


var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")


func check_child_position(child):
	var sprite = child.get_child(0)
	var sprite_width = Vector2(0,0)
	if child.name == "Rock":
		sprite_width.x = round(sprite.texture.get_width() * child.scale.x * sprite.scale.x)
		sprite_width.y = round(sprite.texture.get_height() * child.scale.y * sprite.scale.y)
	
	# if a child is off the side of the screen, wraparound to opposite side		
	if child.position.x > SCREEN_WIDTH + sprite_width.x:
		child.position.x -= SCREEN_WIDTH + sprite_width.x
	elif child.position.x < 0 - sprite_width.x:
		child.position.x += SCREEN_WIDTH + sprite_width.x
		
	if child.position.y > SCREEN_HEIGHT + sprite_width.y:
		child.position.y -= SCREEN_HEIGHT + sprite_width.y
	elif child.position.y < 0 - sprite_width.y:
		child.position.y += SCREEN_HEIGHT + sprite_width.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# in asteroids, if an object moves off one side of the screen, it reappears on the other
	var children = get_children()
	for child in children:
		check_child_position(child)
