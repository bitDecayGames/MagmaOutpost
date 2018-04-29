extends Node2D

export (PackedScene) var Glass

var num_pieces = 8
var tile_size = 32 * 5
var pieces = []

func get_offset(tile_num):
	return tile_num * tile_size

func _ready():
	self.position.x = 100
	var offset = get_offset(num_pieces - 1)
	print("Offset is %d" % offset)
	$Overlay/DispenserMid.position.y = offset
	$Underlay/DispenserBottom.position.y = offset
	
	for i in range(num_pieces - 1):
		print("Spawning pane %d" % i)
		var pane = Glass.instance()
		pane.position.y = get_offset(i)
		pane.modulate.a = 0.50
		$Overlay.add_child(pane)
		
	while pieces.size() < num_pieces:
		print("Creating piece %d" % pieces.size())
		var piece = $PipeFactory.generate_pipe()
		piece.position.x = 0
		piece.position.y = get_offset(pieces.size())
		piece.z_index = 1
		piece.show()
		pieces.append(piece)
		add_child_below_node($Overlay, piece)
