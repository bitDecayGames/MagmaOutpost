extends Node2D

var board_width = 5
var board_height = 5

var tile_size = 32 * 5

export (PackedScene) var Zone

func _ready():
	for x in range(0, board_width):
		for y in range(0, board_height):
			var z = Zone.instance()
			z.position.x = x * tile_size
			z.position.y = y * tile_size
			print("Building zone %d, %d at (%d, %d)" % [x, y, z.position.x, z.position.y])
			add_child(z)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
