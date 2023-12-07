extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
#	pass
	$ScoreWrapper/Score.add_theme_color_override("font_color", Color.BLACK)
#	self.font_color = Color(0, 0, 0, 0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ScoreWrapper/Score.text = str(Utils.score)
