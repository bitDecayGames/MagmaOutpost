extends Node2D

signal zone_clicked(pos)

var clicked = false

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


func _on_Area2D_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton && event.pressed == true:
			print("Clicked a zone!")
			emit_signal("zone_clicked", position)
