extends Node2D

signal board_tile_clicked(pos)

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
			z.connect("zone_clicked", self, "_send_click_sig")
			print("Building zone %d, %d at (%d, %d)" % [x, y, z.position.x, z.position.y])
			add_child(z)

func _send_click_sig(pos):
	print("ClickPosition: %s" % [pos / tile_size])
	emit_signal("board_tile_clicked", pos / tile_size)
	
func set_piece(tile, pos):
	add_child(tile)
	tile.position.x = pos.x * tile_size
	tile.position.y = pos.y * tile_size