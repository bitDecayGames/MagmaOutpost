extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Board_board_tile_clicked(pos):
	var piece = $Dispenser.get_next_piece()
	if piece != null:
		print("Placing piece")
		print("Pos is: %s" % pos)
		$Board.set_piece(piece, pos)
