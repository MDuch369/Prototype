extends Label

var speed = "1"

func _ready():
	text = speed #as String
	
func _input(event):
	if event.is_action_pressed("FasterTime"):
		if speed == "1":
			speed = "2"
		elif speed == "2":
			speed = "4"
		text = speed
		#text = (speed * 2) as String
	elif event.is_action_pressed("SlowerTime"):
		if speed == "2":
			speed = "1"
		elif speed == "4":
			speed = "2"
		text = speed
		#text = (speed / 2) as String
