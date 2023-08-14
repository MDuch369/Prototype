extends TextureProgressBar

func _ready():
	value = 1
	
func _input(event):
	if event.is_action_pressed("FasterTime") and value < 5:
		value += 1
	elif event.is_action_pressed("SlowerTime") and value > 1:
		value -= 1
 
