extends AnimatedSprite

const NO_CONNECTIONS = 0
const LEFT = 1
const UP = 1 << 1
const RIGHT = 1 << 2
const DOWN = 1 << 3
const OVERFLOW = 1 << 4
const SPIN_MASK = LEFT | UP | RIGHT | DOWN

var clockwise_spins = 3

var sprite_size

# sides will be treated as bitflags
# 1 is left
# 2 is up
# 4 is right
# 8 is down
var orientation = 0
export var left_connections = 0
export var up_connections = 0
export var right_connections = 0
export var down_connections = 0

# Pipe should contain information about what edges are connected. This needs to take rotation into account, as well.

func _ready():
	frame = clockwise_spins
	var pipe = get_node(".")
	sprite_size = pipe.frames.get_frame("default", pipe.frame).get_size()
	
	#print("left_con %d" % [left_connections])
	#print("up_con %d" % [up_connections])
	#print("right_con %d" % [right_connections])
	#print("down_con %d" % [down_connections])
	
	# default is left orientation
	if clockwise_spins == 0:
		orientation = LEFT
	if clockwise_spins == 1:
		orientation = UP
	if clockwise_spins == 2:
		orientation = RIGHT
	if clockwise_spins == 3:
		orientation = DOWN
		
	var spun_left = left_connections
	var spun_up = up_connections
	var spun_right = right_connections
	var spun_down = down_connections
	
	if orientation == UP:
		spun_left = down_connections
		spun_up = left_connections
		spun_right = up_connections
		spun_down = right_connections
	if orientation == RIGHT:
		spun_left = right_connections
		spun_up = down_connections
		spun_right = left_connections
		spun_down = up_connections
	if orientation == DOWN:
		spun_left = up_connections
		spun_up = right_connections
		spun_right = down_connections
		spun_down = left_connections
		
	left_connections = _shift_connection_bits(spun_left, clockwise_spins)
	up_connections = _shift_connection_bits(spun_up, clockwise_spins)
	right_connections = _shift_connection_bits(spun_right, clockwise_spins)
	down_connections = _shift_connection_bits(spun_down, clockwise_spins)
	
	#print("left_con %d" % [left_connections])
	#print("up_con %d" % [up_connections])
	#print("right_con %d" % [right_connections])
	#print("down_con %d" % [down_connections])
	
func _shift_connection_bits(connections, cw_spins):
	while cw_spins > 0:
		cw_spins -= 1
		connections = connections << 1
		if connections & OVERFLOW:
			print("Overflow hit")
			# move our overflow spin into left
			connections |= LEFT
			connections &= SPIN_MASK
	return connections
	
	
func _draw():
	if left_connections != NO_CONNECTIONS:
		_debug_draw_side(LEFT, left_connections, Color("0000ff"))
	if up_connections != NO_CONNECTIONS:
		_debug_draw_side(UP, up_connections, Color("ff0000"))
	if right_connections != NO_CONNECTIONS:
		_debug_draw_side(RIGHT, right_connections, Color("00ff00"))
	if down_connections != NO_CONNECTIONS:
		_debug_draw_side(DOWN, down_connections, Color("00ffff"))

func _debug_draw_side(side, connections, color):
	draw_rect(_get_debug_rect(side), color, true)
	if connections & LEFT:
		draw_rect(_get_debug_rect(LEFT), color, true)
	if connections & UP:
		draw_rect(_get_debug_rect(UP), color, true)
	if connections & RIGHT:
		draw_rect(_get_debug_rect(RIGHT), color, true)
	if connections & DOWN:
		draw_rect(_get_debug_rect(DOWN), color, true)
	
func _get_debug_rect(index):
	var rect
	if index == LEFT:
		rect = Rect2(-5, sprite_size.y / 2, 20, 20)
	elif index == UP:
		rect = Rect2(sprite_size.x / 2, -5, 20, 20)
	elif index == RIGHT:
		rect = Rect2(sprite_size.x - 15, sprite_size.y / 2, 20, 20)
	elif index == DOWN:
		rect = Rect2(sprite_size.x / 2, sprite_size.y - 15, 20, 20)
	else:
		rect = Rect2 (0, 0, sprite_size.x, sprite_size.y)
#	rect.position.x -= rect.size.x / 2
#	rect.position.y -= rect.size.y / 2
	return rect
