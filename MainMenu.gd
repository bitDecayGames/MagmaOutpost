extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_TouchScreenButton_released():
	get_tree().change_scene("res://game/Game.tscn")
