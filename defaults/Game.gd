extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if escape is pressed, close the game.
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
