extends Node2D

export (PackedScene) var Glass

var num_pieces = 4
var tile_size = 32 * 5
var pieces = {}
var settled = false

var sizing_speed = 500
var falling_speed = 300

func _get_offset(tile_num):
	return tile_num * tile_size

func _ready():
	var offset = _get_offset(num_pieces - 1)
	print("Offset is %d" % offset)
	$Overlay/DispenserMid.position.y = offset
	$Underlay/DispenserBottom.position.y = offset
	
	$Overlay/GlassPatch.rect_size.x = tile_size
	$Overlay/GlassPatch.rect_size.y = tile_size * (num_pieces - 1)
	$Overlay/GlassPatch.modulate.a = 0.50

func _process(delta):	
	# properly place bottom of dispenser
	_size_dispenser(delta)
	_shift_pieces(delta)
	
	if settled && _room_for_piece():
		_spawn_new_piece()
			
func _shift_pieces(delta):
	# shift pieces down if needed
	for i in range(1, num_pieces):
		i = num_pieces - i
		#print("inspecting piece %d" % i)
		if pieces.has(i):
			continue
		if pieces.has(i - 1) && pieces[i - 1] != null:
			print("Shifting piece %d to %d" % [i-1, i])
			pieces[i] = pieces[i-1]
			pieces.erase(i-1)
	
	# assume settled until we find some piece still settling
	settled = true
	for piece_num in pieces.keys():
		if pieces[piece_num].position.y < _get_offset(piece_num):
			settled = false
			pieces[piece_num].position.y += falling_speed * delta
		if pieces[piece_num].position.y >= _get_offset(piece_num):
			pieces[piece_num].position.y = _get_offset(piece_num)
			
func _size_dispenser(delta):
	if $Underlay/DispenserBottom.position.y < _get_offset(num_pieces - 1):
		$Underlay/DispenserBottom.position.y += sizing_speed * delta
		$Overlay/DispenserMid.position.y = $Underlay/DispenserBottom.position.y
	else:
		$Underlay/DispenserBottom.position.y = _get_offset(num_pieces - 1)
		$Overlay/DispenserMid.position.y = _get_offset(num_pieces - 1)
	$Overlay/GlassPatch.rect_size.y = $Underlay/DispenserBottom.position.y
			
func _room_for_piece():
	return !pieces.has(0)
	
func _spawn_new_piece():
	var piece = $PipeFactory.generate_pipe()
	piece.position.x = 0
	piece.position.y = 0
	piece.z_index = 1
	piece.show()
	pieces[0] = piece
	add_child_below_node($Overlay, piece)
	
func get_next_piece():
	if pieces.has(num_pieces-1):
		var piece = pieces[num_pieces-1]
		pieces[num_pieces - 1].queue_free()
		pieces.erase(num_pieces-1)
		return piece
	else:
		return null

func _on_Spawn_timeout():
	if _room_for_piece():
		_spawn_new_piece()


func _on_DebugConsume_timeout():
	print("Debug consume")
	get_next_piece()


func _on_DebugExpand_timeout():
	num_pieces += 1
