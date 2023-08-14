extends Panel

@onready var unit = $"../.."
@onready var ammo = $"../../Modules/Cannon"
#@onready var timer = $"../Timer"
#var low_ammo = false

func _ready():
	visible = false
	get_tree().get_root().get_node("World").get_node("UI").connect_to_timer(self)
	
func _on_timer_timeout():
	if ammo.current_resources < 20:
		visible = !visible
	else:
		visible = false
