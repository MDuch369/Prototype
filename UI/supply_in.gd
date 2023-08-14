extends Panel

@onready var unit = $"../.."
var showing = false

func _ready():
	visible = false
	get_tree().get_root().get_node("World").get_node("UI").connect_to_timer(self)

func _on_timer_timeout():
	if showing == true:
		visible = !visible
	else:
		visible = false
