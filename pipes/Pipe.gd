extends AnimatedSprite

var pipe_rotation = 0

# Pipe should contain information about what edges are connected. This needs to take rotation into account, as well.

func _ready():
	frame = pipe_rotation
	

func _process(delta):
	pass
