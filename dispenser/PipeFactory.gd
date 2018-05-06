extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var scenes = {
	"CornerPipe": load("res://pipes/CornerPipe.tscn"),
	"CrossoverPipe": load("res://pipes/CrossoverPipe.tscn"),
	"FourWayPipe": load("res://pipes/FourWayPipe.tscn"),
	"StraightPipe": load("res://pipes/StraightPipe.tscn"),
	"TeePipe": load("res://pipes/TeePipe.tscn"),
	}

var piece_odds = {
	"CornerPipe": .2,
	"CrossoverPipe": .2,
	"FourWayPipe": .2,
	"StraightPipe": .2,
	"TeePipe": .2
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func generate_pipe():
	var selection = ""
	var rand = randf()
	var child_num = -1
	for category in piece_odds.keys():
		child_num += 1
		if rand <= piece_odds[category]:
			# this is our thing
			selection = category
			break
		else:
			rand -= piece_odds[category]
	var piece = scenes[selection].instance()
	piece.clockwise_spins = randi() % 4
	print("Generating a %s with %d spins" % [selection, piece.clockwise_spins])
	return piece