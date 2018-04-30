extends Node2D

export (PackedScene) var Glass

var num_pieces = 4
var tile_size = 32 * 5
var pieces = {}

var sizing_speed = 500
var falling_speed = 300

func get_offset(tile_num):
	return tile_num * tile_size

func _ready():
	self.position.x = 100
	var offset = get_offset(num_pieces - 1)
	print("Offset is %d" % offset)
	$Overlay/DispenserMid.position.y = offset
	$Underlay/DispenserBottom.position.y = offset
	
	$Overlay/GlassPatch.rect_size.x = tile_size
	$Overlay/GlassPatch.rect_size.y = tile_size * (num_pieces - 1)
	$Overlay/GlassPatch.modulate.a = 0.50
	
	#for i in range(num_pieces - 1):
	#	print("Spawning pane %d" % i)
	#	var pane = Glass.instance()
	#	pane.position.y = get_offset(i)
	#	pane.modulate.a = 0.50
	#	$Overlay.add_child(pane)

var time_passed = 0
var eat_piece = 0
var resize_timer = 4.6

func _process(delta):
	# test code
	time_passed += delta
	if time_passed >= 1:
		time_passed = 0
		if room_for_piece():
			spawn_new_piece()
			
	eat_piece += delta
	if eat_piece >= 3:
		eat_piece = 0
		if pieces.has(num_pieces - 1):
			pieces[num_pieces - 1].queue_free()
			pieces.erase(num_pieces - 1)
			
	resize_timer -= delta
	if resize_timer <= 0:
		num_pieces += 1
		resize_timer = 4.6
	# end test code
	
	# properly place bottom of dispenser
	size_dispenser(delta)
	
	# shift pieces down if needed
	for i in range(0, num_pieces - 1):
		#print("inspecting piece %d" % i)
		if !pieces.has(i):
			continue
		if !pieces.has(i + 1) || pieces[i + 1] == null:
			print("Shifting piece %d to %d" % [i, i+1])
			pieces[i + 1] = pieces[i]
			pieces.erase(i)
		
	for piece_num in pieces.keys():
		if pieces[piece_num].position.y < get_offset(piece_num):
			pieces[piece_num].position.y += falling_speed * delta
		else:
			pieces[piece_num].position.y = get_offset(piece_num)
			
func size_dispenser(delta):
	if $Underlay/DispenserBottom.position.y < get_offset(num_pieces - 1):
		$Underlay/DispenserBottom.position.y += sizing_speed * delta
		$Overlay/DispenserMid.position.y = $Underlay/DispenserBottom.position.y
	else:
		$Underlay/DispenserBottom.position.y = get_offset(num_pieces - 1)
		$Overlay/DispenserMid.position.y = get_offset(num_pieces - 1)
	$Overlay/GlassPatch.rect_size.y = $Underlay/DispenserBottom.position.y
			
func room_for_piece():
	return !pieces.has(0)
	
func spawn_new_piece():
	print("Creating piece")
	var piece = $PipeFactory.generate_pipe()
	piece.position.x = 0
	#piece.position.y = get_offset(pieces.size())
	piece.z_index = 1
	piece.show()
	pieces[0] = piece
	add_child_below_node($Overlay, piece)
	
func get_next_piece():
	var piece = pieces[num_pieces]
	if pieces[num_pieces] != null:
		pieces.erase(num_pieces)
	return piece