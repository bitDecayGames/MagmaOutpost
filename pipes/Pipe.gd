extends AnimatedSprite

var pipe_rotation = 0

var sprite_size

# 0 is left
# 1 is up
# 2 is right
# 3 is down
export var side_0_connections = []
export var side_1_connections = []
export var side_2_connections = []
export var side_3_connections = []

# Pipe should contain information about what edges are connected. This needs to take rotation into account, as well.

func _ready():
	frame = pipe_rotation
	var pipe = get_node(".")
	sprite_size = pipe.frames.get_frame("default", pipe.frame).get_size()

func _process(delta):
	pass
	
func _draw():
	if side_0_connections.size() > 0:
		_debug_draw_side(0, side_0_connections, Color("0000ff"))
	if side_1_connections.size() > 0:
		_debug_draw_side(1, side_1_connections, Color("ff0000"))
	if side_2_connections.size() > 0:
		_debug_draw_side(2, side_2_connections, Color("00ff00"))
	if side_3_connections.size() > 0:
		_debug_draw_side(3, side_3_connections, Color("00ffff"))

func _debug_draw_side(side, connections, color):
	draw_rect(_get_debug_rect(side), color, true)
	for con in connections:
		draw_rect(_get_debug_rect(con), color, true)
	
func _get_debug_rect(index):
	if index == 0:
		return Rect2(0, sprite_size.y / 2, 20, 20)
	if index == 1:
		return Rect2(sprite_size.x / 2, 0, 20, 20)
	if index == 2:
		return Rect2(sprite_size.x, sprite_size.y / 2, 20, 20)
	if index == 3:
		return Rect2(sprite_size.x / 2, sprite_size.y, 20, 20)
