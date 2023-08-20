extends InfantryPropulsion

func _ready():
#	super()
	type = "legs"
	required_crew = 1
	movement_speed = 20.0
	rotation_speed = PI


func _on_moving_state_physics_processing(delta):
	super(delta)
