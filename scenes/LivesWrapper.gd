extends Node2D


@onready var sprites = self.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(sprites);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Utils.lives < 3:
		for i in range(2, Utils.lives-1, -1):
			sprites[i].set_visible(false)

