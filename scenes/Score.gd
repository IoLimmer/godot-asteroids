extends Label


var mainText = "Score: "

func _process(delta):
	self.text = mainText + str(Utils.score)

