extends Propulsion

func _ready():
	super()
	type = "legs"
	max_resources = 500.0
	current_resources = 500.0
	resource_transfer_cost = 1.0
	resource_usage = 2.0
	required_crew = 1
	movement_speed = 100.0
	rotation_speed = PI / 2
