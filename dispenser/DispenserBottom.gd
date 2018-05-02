extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)

func _on_ClickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
        print("Clicked!")
